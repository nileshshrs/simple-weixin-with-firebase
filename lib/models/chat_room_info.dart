// chat_info_model.dart

class ChatInfoModel {
  final String chatRoomId;
  final String otherUsername;
  final String lastMessageContent;

  ChatInfoModel({
    required this.chatRoomId,
    required this.otherUsername,
    required this.lastMessageContent,
  });
}
