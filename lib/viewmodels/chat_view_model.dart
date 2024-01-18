import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_application/services/sharedpreferences_service.dart';

class ChatViewModel {
  String loggedInUserId = '';
  String loggedInUsername = '';
  String otherUserId = '';
  String otherUsername = '';

  Future<void> fetchUsernames(String chatRoomId) async {
    try {
      Map<String, String?> loggedInUserData =
      await SharedPreferencesService.getUserData();
      loggedInUserId = loggedInUserData['id'] ?? '';
      loggedInUsername = loggedInUserData['username'] ?? '';

      DocumentSnapshot chatRoomDoc = await FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(chatRoomId)
          .get();

      if (chatRoomDoc.exists) {
        List<String> userIDs = List.from(chatRoomDoc['users'] ?? []);
        List<String> usernames = List.from(chatRoomDoc['user_names'] ?? []);

        if (userIDs.length == 2 && usernames.length == 2) {
          otherUserId = userIDs.firstWhere((id) => id != loggedInUserId);
          otherUsername =
              usernames.firstWhere((username) => username != loggedInUsername);
        }
      }
    } catch (error) {
      print('Error fetching usernames: $error');
    }
  }

}
