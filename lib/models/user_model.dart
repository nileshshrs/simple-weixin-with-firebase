// lib/models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String username;
  final String email;
  final DateTime createdAt;
  final String image;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.createdAt,
    required this.image,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      image: map['image'],
    );
  }

  @override
  String toString() {
    return 'UserModel{id: $id, username: $username, email: $email, createdAt: $createdAt, image: $image}';
  }
}
