import 'package:flutter/material.dart';

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
