import 'package:firebase_chat_application/viewmodels/chat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


class ChatRoomPage extends StatefulWidget {
  final String chatRoomId;

  const ChatRoomPage({Key? key, required this.chatRoomId}) : super(key: key);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController _messageController = TextEditingController();
  ChatViewModel _chatViewModel = ChatViewModel(); // Integrate ChatViewModel

  @override
  void initState() {
    super.initState();
    fetchUsernames();
  }

  void fetchUsernames() async {
    try {
      await _chatViewModel.fetchUsernames(widget.chatRoomId);

      setState(() {});
    } catch (error) {
      print('Error fetching usernames: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_chatViewModel.otherUsername),
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
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3EB575)),
                    ),
                  );
                }

                List<Message> messages = snapshot.data!.docs.map((doc) {
                  return Message.fromMap(doc.data() as Map<String, dynamic>);
                }).toList();

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    bool isOtherUser = messages[index].sender == _chatViewModel.otherUsername;

                    return ListTile(
                      title: Column(
                        crossAxisAlignment: isOtherUser
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: isOtherUser
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.end,
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
                              color: isOtherUser
                                  ? Color(0xFF3EB575)
                                  : Colors.white,
                              borderRadius: isOtherUser
                                  ? BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              )
                                  : BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                              boxShadow: isOtherUser
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
                                color: isOtherUser ? Colors.white : Colors.black,
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
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF3EB575),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF3EB575),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    sendMessage();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3EB575),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: Text(
                    'Send',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String formatDate(String timestamp) {
    DateTime dateTime = DateTime.tryParse(timestamp) ?? DateTime.now();
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
        'sender': _chatViewModel.loggedInUsername,
        'timestamp': FieldValue.serverTimestamp(),
      }).then((_) {
        FirebaseFirestore.instance
            .collection('chat_rooms')
            .doc(widget.chatRoomId)
            .update({
          'created_at': FieldValue.serverTimestamp(),
          'last_message.content': content,
          'last_message.sender': _chatViewModel.loggedInUsername,
          'last_message.timestamp': FieldValue.serverTimestamp(),
        });
      });

      _messageController.clear();
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
