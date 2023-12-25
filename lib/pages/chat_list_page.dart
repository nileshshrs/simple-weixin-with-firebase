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
      // Fetch chat rooms based on the username
      String? loggedInUsername =
          (await SharedPreferencesService.getUserData())['username'];
      List<ChatRoomInfo> chatRooms =
          await searchChatRooms(loggedInUsername ?? '');
      setState(() {
        _chatRooms = chatRooms;
      });
    } catch (error) {
      print('Error fetching chat rooms: $error');
      // Handle the error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_chatRooms.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _chatRooms.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Other User: ${_chatRooms[index].otherUsername}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                            'Last Message: ${_chatRooms[index].lastMessageContent}'),
                      ],
                    ),
                    onTap: () {
                      // Use the chat room ID for navigation or other actions
                      String chatRoomId = _chatRooms[index].chatRoomId;
                      print('Selected Chat Room ID: $chatRoomId');
                      // Add navigation or other actions as needed
                    },
                  );
                },
              ),
            ),
          if (_chatRooms.isEmpty) Text('No chat rooms found for the user.'),
        ],
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
    // Reference to the 'chat_rooms' collection
    CollectionReference chatRoomsCollection =
        FirebaseFirestore.instance.collection('chat_rooms');

    // Fetch chat rooms where the provided username is present in user_names array
    QuerySnapshot chatRoomsSnapshot = await chatRoomsCollection
        .where('user_names', arrayContains: username)
        .orderBy('created_at', descending: true)
        .get();

    // Extract chat room information from the documents
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
    throw error; // Handle the error as needed
  }
}
