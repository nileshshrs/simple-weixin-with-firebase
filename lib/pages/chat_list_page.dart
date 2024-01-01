import 'dart:async';

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
  StreamSubscription<QuerySnapshot>? _chatRoomsSubscription;

  @override
  void initState() {
    super.initState();
    _setupChatRoomsListener();
  }

  void _setupChatRoomsListener() async {
    String? loggedInUsername = (await SharedPreferencesService.getUserData())['username'];
    Stream<QuerySnapshot> chatRoomsStream = FirebaseFirestore.instance
        .collection('chat_rooms')
        .where('user_names', arrayContains: loggedInUsername)
        .orderBy('created_at', descending: true)
        .snapshots();

    _chatRoomsSubscription = chatRoomsStream.listen((QuerySnapshot snapshot) {
      List<ChatRoomInfo> chatRooms = snapshot.docs.map((doc) {
        List<String> userNames = List.from(doc['user_names'] ?? []);
        String otherUsername = userNames.firstWhere((name) => name != loggedInUsername);
        String lastMessageContent = doc['last_message']['content'] ?? 'No messages yet';
        return ChatRoomInfo(
          chatRoomId: doc.id,
          otherUsername: otherUsername,
          lastMessageContent: lastMessageContent,
        );
      }).toList();

      setState(() {
        _chatRooms = chatRooms;
      });
    });
  }

  @override
  void dispose() {
    _chatRoomsSubscription?.cancel();
    super.dispose();
  }

  Future<void> deleteChatRoom(String chatRoomId) async {
    try {
      DocumentSnapshot documentSnapshot =
      await FirebaseFirestore.instance.collection('chat_rooms').doc(chatRoomId).get();

      if (documentSnapshot.exists) {
        print(chatRoomId);
        await FirebaseFirestore.instance.collection('chat_rooms').doc(chatRoomId).delete();
        print('Chat room deleted successfully.');
      } else {
        print('Chat room does not exist.');
      }
    } catch (error) {
      print('Error deleting chat room: $error');
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

  void _showPopupMenu(ChatRoomInfo chatRoomInfo, GlobalKey key, String chatroomid) async {
    RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    double screenWidth = MediaQuery.of(context).size.width;
    double xPosition = position.dx > (screenWidth / 2) ? position.dx - 150 : position.dx + renderBox.size.width;

    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(xPosition, position.dy, 0, 0),
      items: <PopupMenuEntry>[
        PopupMenuItem(
          child: GestureDetector(
            onTap: () async {
              await deleteChatRoom(chatroomid);
              Navigator.pop(context);
            },
            child: Text('Delete'),
          ),
        ),
      ],
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
                      GlobalKey _key = GlobalKey();

                      return Column(
                        children: [
                          ListTile(
                            key: _key,
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
                            onLongPress: () {
                              _showPopupMenu(_chatRooms[index], _key, _chatRooms[index].chatRoomId);
                            },
                          ),
                          Divider(
                            height: .2,
                            color: Color.fromRGBO(220, 220, 220, .8),
                          ),
                        ],
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
