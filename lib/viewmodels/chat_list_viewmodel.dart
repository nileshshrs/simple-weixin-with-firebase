import 'dart:async';
import 'package:firebase_chat_application/models/user_model.dart';
import 'package:firebase_chat_application/repositories/chat_room_repository.dart';
import 'package:firebase_chat_application/viewmodels/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_room_model.dart';


class ChatListViewModel with ChangeNotifier {
  final ChatRoomRepository _repository = ChatRoomRepository();
  final LoginViewModel _loginViewModel = LoginViewModel();
  List<ChatRoomInfo> _chatRooms = [];
  StreamSubscription<QuerySnapshot<Object?>>? _chatRoomsSubscription;

  List<ChatRoomInfo> get chatRooms => _chatRooms;

  void setupChatRoomsListener() async {
    UserModel? loggedInUser = await _loginViewModel.getUserDataFromPreferences();
    if (loggedInUser != null) {
      Stream<QuerySnapshot<Object?>> chatRoomsStream = _repository
          .getChatRooms(loggedInUser.id);

      _chatRoomsSubscription = chatRoomsStream.listen((QuerySnapshot<Object?> snapshot) {
        List<ChatRoomInfo> chatRooms = snapshot.docs.map((doc) {
          List<String> userNames = List.from(doc['user_names'] ?? []);
          String otherUsername = userNames.firstWhere((name) => name != loggedInUser.id);
          String lastMessageContent = doc['last_message']['content'] ?? 'No messages yet';
          return ChatRoomInfo(
            chatRoomId: doc.id,
            otherUsername: otherUsername,
            lastMessageContent: lastMessageContent,
          );
        }).toList();

        _chatRooms = chatRooms;
        notifyListeners();
      });
    }
  }

  Future<void> deleteChatRoom(String chatRoomId) async {
    await _repository.deleteChatRoom(chatRoomId);
  }

  void dispose() {
    _chatRoomsSubscription?.cancel();
    super.dispose();
  }
}
