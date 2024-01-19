import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomRepository {
  Stream<QuerySnapshot<Object?>> getChatRooms(String loggedInUserId) {
    return FirebaseFirestore.instance
        .collection('chat_rooms')
        .where('user_names', arrayContains: loggedInUserId)
        .orderBy('created_at', descending: true)
        .snapshots();
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
}
