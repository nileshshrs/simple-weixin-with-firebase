import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_application/services/sharedpreferences_service.dart';

class ChatService {
  Future<void> createChatRoom(String otherUserId, String otherUsername) async {
    try {
      Map<String, String?> loggedInUserData = await SharedPreferencesService.getUserData();
      String? loggedInUserId = loggedInUserData['id'];
      String? loggedInUsername = loggedInUserData['username'];

      if (loggedInUserId != null && loggedInUsername != null) {
        // Construct the chat room ID based on user IDs
        String chatRoomId = constructChatRoomId(loggedInUserId, otherUserId);

        // Check if the chat room already exists
        DocumentSnapshot chatRoomDoc = await FirebaseFirestore.instance
            .collection('chat_rooms')
            .doc(chatRoomId)
            .get();

        if (!chatRoomDoc.exists) {
          // Chat room doesn't exist, create it
          await FirebaseFirestore.instance
              .collection('chat_rooms')
              .doc(chatRoomId)
              .set({
            'users': [loggedInUserId, otherUserId],
            'user_names': [loggedInUsername, otherUsername],
            'last_message': {
              'content': 'Chat started',
              'sender': loggedInUserId,
              'timestamp': FieldValue.serverTimestamp(),
            },
            'created_at': FieldValue.serverTimestamp(),
          });

          // Create a messages sub-collection within the chat room
          await FirebaseFirestore.instance
              .collection('chat_rooms')
              .doc(chatRoomId)
              .collection('messages')
              .add({
            'content': 'Chat started',
            'sender': loggedInUserId,
            'timestamp': FieldValue.serverTimestamp(),
          });

          print("Chat room created");
        }
      } else {
        throw 'User ID or username not found in shared preferences';
      }
    } catch (error) {
      throw 'Error creating chat room: $error';
    }
  }

  String constructChatRoomId(String userId1, String userId2) {
    List<String> sortedUserIds = [userId1, userId2]..sort();
    return '${sortedUserIds[0]}_${sortedUserIds[1]}';
  }
}
