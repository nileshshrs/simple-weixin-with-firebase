// chat_list_repository.dart
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weixin/models/chat_room_info.dart';

class ChatListRepository {
  late StreamController<List<ChatInfoModel>> _chatRoomsController;
  late Stream<List<ChatInfoModel>> chatRoomsStream;

  ChatListRepository() {
    _chatRoomsController = StreamController<List<ChatInfoModel>>();
    chatRoomsStream = _chatRoomsController.stream;
  }

  Stream<List<ChatInfoModel>> getChatRooms(String? loggedInUsername) {
    try {
      FirebaseFirestore.instance
          .collection('chat_rooms')
          .where('user_names', arrayContains: loggedInUsername)
          .orderBy('created_at', descending: true)
          .snapshots()
          .listen((QuerySnapshot snapshot) {
        if (!_chatRoomsController.isClosed) {
          List<ChatInfoModel> chatRooms = snapshot.docs.map((doc) {
            List<String> userNames = List.from(doc['user_names'] ?? []);
            String otherUsername = userNames.firstWhere((name) => name != loggedInUsername);
            String lastMessageContent = doc['last_message']['content'] ?? 'No messages yet';

            return ChatInfoModel(
              chatRoomId: doc.id,
              otherUsername: otherUsername,
              lastMessageContent: lastMessageContent,
            );
          }).toList();

          _chatRoomsController.add(chatRooms);
        }
      });

      return chatRoomsStream;
    } catch (error) {
      print('Error fetching chat rooms: $error');
      return Stream.value([]);
    }
  }

  Future<void> deleteChatRoom(String chatRoomId) async {
    try {
      DocumentSnapshot documentSnapshot =
      await FirebaseFirestore.instance.collection('chat_rooms').doc(chatRoomId).get();

      if (documentSnapshot.exists) {
        await FirebaseFirestore.instance.collection('chat_rooms').doc(chatRoomId).delete();
        print('Chat room deleted successfully.');
      } else {
        print('Chat room does not exist.');
      }
    } catch (error) {
      print('Error deleting chat room: $error');
    }
  }

  void dispose() {
    if (!_chatRoomsController.isClosed) {
      _chatRoomsController.close();
    }
  }
}
