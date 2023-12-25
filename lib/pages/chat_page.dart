import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_application/services/sharedpreferences_service.dart';

class ChatRoomPage extends StatefulWidget {
  final String chatRoomId;

  const ChatRoomPage({Key? key, required this.chatRoomId}) : super(key: key);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String loggedInUserId = ''; // Updated to use SharedPreferencesService
  String loggedInUsername = ''; // Updated to use SharedPreferencesService
  String otherUserId = '';
  String otherUsername = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Room'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chat_rooms')
                  .doc(widget.chatRoomId)
                  .collection('messages')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List<Message> messages = snapshot.data!.docs.map((doc) {
                  return Message.fromMap(doc.data() as Map<String, dynamic>);
                }).toList();

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(messages[index].content),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Text(messages[index].sender, style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(messages[index].timestamp),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    sendMessage();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void sendMessage() {
    String content = _messageController.text.trim();
    if (content.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(widget.chatRoomId)
          .collection('messages')
          .add({
        'content': content,
        'sender': loggedInUsername,
        'timestamp': FieldValue.serverTimestamp(),
      }).then((_) {
        // Update the last_message field in the chat_rooms collection after sending a new message
        FirebaseFirestore.instance
            .collection('chat_rooms')
            .doc(widget.chatRoomId)
            .update({
          'last_message.content': content,
          'last_message.sender': loggedInUserId,
          'last_message.timestamp': FieldValue.serverTimestamp(),
        });
      });

      _messageController.clear();
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch the usernames when the widget is initialized
    fetchUsernames();
  }

  void fetchUsernames() async {
    try {
      Map<String, String?> loggedInUserData = await SharedPreferencesService.getUserData();
      loggedInUserId = loggedInUserData['id'] ?? '';
      loggedInUsername = loggedInUserData['username'] ?? '';

      DocumentSnapshot chatRoomDoc = await FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(widget.chatRoomId)
          .get();

      if (chatRoomDoc.exists) {
        List<String> userIDs = List.from(chatRoomDoc['users'] ?? []);
        List<String> usernames = List.from(chatRoomDoc['user_names'] ?? []);

        if (userIDs.length == 2 && usernames.length == 2) {
          otherUserId = userIDs.firstWhere((id) => id != loggedInUserId);
          otherUsername = usernames.firstWhere((username) => username != loggedInUsername);

          // Display the other user's username
          setState(() {});
        }
      }
    } catch (error) {
      print('Error fetching usernames: $error');
    }
  }
}

class Message {
  final String content;
  final String sender;
  final String timestamp;

  Message({
    required this.content,
    required this.sender,
    required this.timestamp,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      content: map['content'] ?? '',
      sender: map['sender'] ?? '',
      timestamp: map['timestamp'] != null
          ? (map['timestamp'] as Timestamp).toDate().toString()
          : '',
    );
  }
}
