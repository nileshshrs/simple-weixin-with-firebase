// chat_view_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_application/models/user_model.dart';
import 'package:firebase_chat_application/repositories/chat_repository.dart';
import 'package:firebase_chat_application/viewmodels/login_view_model.dart';

class ChatViewModel {
  String loggedInUserId = '';
  String loggedInUsername = '';
  String otherUserId = '';
  String otherUsername = '';

  ChatRepository _chatRepository = ChatRepository();
  LoginViewModel _loginViewModel = LoginViewModel();

  Future<void> fetchUsernames(String chatRoomId) async {
    try {
      // Retrieve user data from preferences using LoginViewModel
      UserModel? loggedInUser = await _loginViewModel.getUserDataFromPreferences();

      if (loggedInUser != null) {
        loggedInUserId = loggedInUser.id;
        loggedInUsername = loggedInUser.username;

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
      }
    } catch (error) {
      print('Error fetching usernames: $error');
    }
  }

  Future<void> sendMessage(String chatRoomId, String content) async {
    try {
      // Use loggedInUsername directly from LoginViewModel
      UserModel? loggedInUser = await _loginViewModel.getUserDataFromPreferences();
      if (loggedInUser != null) {
        await _chatRepository.sendMessage(chatRoomId, content, loggedInUsername);
      }
    } catch (error) {
      print('Error sending message: $error');
      throw 'Error sending message: $error';
    }
  }
}
