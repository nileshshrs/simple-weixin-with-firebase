// message_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String content;
  final String sender;
  final Timestamp timestamp; // Change this line to use Timestamp directly

  Message({
    required this.content,
    required this.sender,
    required this.timestamp,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      content: map['content'] ?? '',
      sender: map['sender'] ?? '',
      timestamp: map['timestamp'] as Timestamp? ?? Timestamp.now(),
    );
  }
}
