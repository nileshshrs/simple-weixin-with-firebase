// chat_list_view_model.dart
import 'package:weixin/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:weixin/models/chat_room_info.dart';
import 'package:weixin/repositories/chat_list_repository.dart';
import 'package:weixin/viewmodels/login_view_model.dart';

class ChatListViewModel extends ChangeNotifier {
  final ChatListRepository _repository = ChatListRepository();
  Stream<List<ChatInfoModel>> _chatRoomsStream = Stream.empty();

  Stream<List<ChatInfoModel>> get chatRoomsStream => _chatRoomsStream;

  void initChatRoomsListener() async {
    // Create an instance of LoginViewModel
    LoginViewModel _loginViewModel = LoginViewModel();

    // Use the LoginViewModel to get user data from preferences
    UserModel? loggedInUser = await _loginViewModel.getUserDataFromPreferences();

    if (loggedInUser != null) {
      String loggedInUsername = loggedInUser.username;

      // Initialize the chatRoomsStream with the stream from the repository
      _chatRoomsStream = _repository.getChatRooms(loggedInUsername);

      // Notify listeners that the stream has been updated
      notifyListeners();
    } else {
      print('Error fetching user data. User not logged in?');
    }
  }

  Future<void> deleteChatRoom(String chatRoomId) async {
    await _repository.deleteChatRoom(chatRoomId);
  }

  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }
}
