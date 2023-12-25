import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_application/services/sharedpreferences_service.dart';
import 'package:intl/intl.dart';


class ChatRoomPage extends StatefulWidget {
  final String chatRoomId;

  const ChatRoomPage({Key? key, required this.chatRoomId}) : super(key: key);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String loggedInUserId = '';
  String loggedInUsername = '';
  String otherUserId = '';
  String otherUsername = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(otherUsername),
        backgroundColor: Color(0xFFEDEDED),
      ),
      backgroundColor: Color(0xFFEDEDED),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chat_rooms')
                  .doc(widget.chatRoomId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
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
                  reverse:true,
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Column(
                        crossAxisAlignment: messages[index].sender == loggedInUsername
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: messages[index].sender == loggedInUsername
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              Text(
                                messages[index].sender,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * (2 / 3),
                            decoration: BoxDecoration(
                              color: messages[index].sender == loggedInUsername
                                  ? Colors.green
                                  : Colors.white,
                              borderRadius: messages[index].sender == loggedInUsername
                                  ? BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              )
                                  : BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                              boxShadow: messages[index].sender == loggedInUsername
                                  ? [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(0, 2),
                                ),
                              ]
                                  : [],
                            ),
                            padding: EdgeInsets.all(8),
                            child: Text(
                              messages[index].content,
                              style: TextStyle(
                                color: messages[index].sender == loggedInUsername
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            formatDate(messages[index].timestamp),
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
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

  String formatDate(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    String formattedDate =
        '${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year.toString().substring(2)} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    return formattedDate;
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
        FirebaseFirestore.instance
            .collection('chat_rooms')
            .doc(widget.chatRoomId)
            .update({
          'last_message.content': content,
          'last_message.sender': loggedInUsername,
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
      timestamp: map['timestamp'] is Timestamp
          ? (map['timestamp'] as Timestamp).toDate().toString()
          : '',
    );
  }

}
