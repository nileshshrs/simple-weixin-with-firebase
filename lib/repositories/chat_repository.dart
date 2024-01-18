import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createChatRoom(
      String? loggedInUserId,
      String? loggedInUsername,
      String? otherUserId,
      String? otherUsername,
      ) async {
    try {
      // Ensure non-null values for required parameters
      if (loggedInUserId == null || loggedInUsername == null || otherUserId == null || otherUsername == null) {
        throw ArgumentError('One or more parameters are null');
      }

      // Construct the chat room ID based on user IDs
      String chatRoomId = constructChatRoomId(loggedInUserId, otherUserId);

      // Check if the chat room already exists
      DocumentSnapshot chatRoomDoc =
      await _firestore.collection('chat_rooms').doc(chatRoomId).get();

      if (!chatRoomDoc.exists) {
        // Chat room doesn't exist, create it
        await _firestore.collection('chat_rooms').doc(chatRoomId).set({
          'users': [loggedInUserId, otherUserId],
          'user_names': [loggedInUsername, otherUsername],
          'last_message': {
            'content': 'Chat started',
            'sender': loggedInUsername,
            'timestamp': FieldValue.serverTimestamp(),
          },
          'created_at': FieldValue.serverTimestamp(),
        });

        // Create a messages sub-collection within the chat room
        await _firestore
            .collection('chat_rooms')
            .doc(chatRoomId)
            .collection('messages')
            .add({
          'content': 'Let\'s chat!',
          'sender': loggedInUsername,
          'timestamp': FieldValue.serverTimestamp(),
        });

        print("Chat room created");

        return chatRoomId; // Return the chat room ID
      } else {
        // Return a default value if the chat room already exists
        print("Chat room with ID $chatRoomId already exists");
        return chatRoomId; // You can use an empty string or another default value
      }
    } catch (error) {
      // Handle specific exceptions and provide meaningful error messages
      print('Error creating chat room: $error');
      throw 'Error creating chat room: $error';
    }
  }

  String constructChatRoomId(String userId1, String userId2) {
    List<String> sortedUserIds = [userId1, userId2]..sort();
    return '${sortedUserIds[0]}_${sortedUserIds[1]}';
  }

  Future<void> sendMessage(String chatRoomId, String content, String loggedInUsername) async {
    try {
      if (content.isNotEmpty) {
        await _firestore
            .collection('chat_rooms')
            .doc(chatRoomId)
            .collection('messages')
            .add({
          'content': content,
          'sender': loggedInUsername,
          'timestamp': FieldValue.serverTimestamp(),
        });

        await _firestore
            .collection('chat_rooms')
            .doc(chatRoomId)
            .update({
          'created_at': FieldValue.serverTimestamp(),
          'last_message.content': content,
          'last_message.sender': loggedInUsername,
          'last_message.timestamp': FieldValue.serverTimestamp(),
        });
      }
    } catch (error) {
      print('Error sending message: $error');
      throw 'Error sending message: $error';
    }
  }
}
