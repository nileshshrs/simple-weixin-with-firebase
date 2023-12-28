import 'package:firebase_chat_application/pages/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_application/services/sharedpreferences_service.dart';

class ChatListPage extends StatefulWidget {
  static const String routeName = '/chatList';

  const ChatListPage();

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  List<ChatRoomInfo> _chatRooms = [];

  @override
  void initState() {
    super.initState();
    fetchChatRooms();
  }

  Future<void> fetchChatRooms() async {
    try {
      String? loggedInUsername =
      (await SharedPreferencesService.getUserData())['username'];
      List<ChatRoomInfo> chatRooms =
      await searchChatRooms(loggedInUsername ?? '');
      setState(() {
        _chatRooms = chatRooms;
      });
    } catch (error) {
      print('Error fetching chat rooms: $error');
    }
  }

  void navigateToChatRoom(String chatRoomId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatRoomPage(chatRoomId: chatRoomId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_chatRooms.isNotEmpty)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: ListView.builder(
                    itemCount: _chatRooms.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(_chatRooms[index].chatRoomId),
                        background: Container(
                          color: Colors.red, // Background color for delete button
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (direction) {
                          // Handle the dismissal, e.g., delete the chat room
                        },
                        child: Column(
                          children: [
                            ListTile(
                              // Your existing ListTile content
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${_chatRooms[index].otherUsername}',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    '${_chatRooms[index].lastMessageContent}',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              onTap: () {
                                String chatRoomId = _chatRooms[index].chatRoomId;
                                navigateToChatRoom(chatRoomId);
                                print('Selected Chat Room ID: $chatRoomId');
                              },
                            ),
                            Divider(
                              height: .2,
                              color: Color.fromRGBO(220, 220, 220, .8),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            if (_chatRooms.isEmpty) Text('No chat rooms found for the user.'),
          ],
        ),
      ),
    );
  }
}

class ChatRoomInfo {
  final String chatRoomId;
  final String otherUsername;
  final String lastMessageContent;

  ChatRoomInfo({
    required this.chatRoomId,
    required this.otherUsername,
    required this.lastMessageContent,
  });
}

Future<List<ChatRoomInfo>> searchChatRooms(String username) async {
  try {
    CollectionReference chatRoomsCollection =
    FirebaseFirestore.instance.collection('chat_rooms');

    QuerySnapshot chatRoomsSnapshot = await chatRoomsCollection
        .where('user_names', arrayContains: username)
        .orderBy('created_at', descending: true)
        .get();

    List<ChatRoomInfo> chatRooms = chatRoomsSnapshot.docs.map((doc) {
      List<String> userNames = List.from(doc['user_names'] ?? []);
      String otherUsername = userNames.firstWhere((name) => name != username);
      String lastMessageContent =
          doc['last_message']['content'] ?? 'No messages yet';
      return ChatRoomInfo(
          chatRoomId: doc.id,
          otherUsername: otherUsername,
          lastMessageContent: lastMessageContent);
    }).toList();

    return chatRooms;
  } catch (error) {
    print('Error searching for chat rooms: $error');
    throw error;
  }
}
