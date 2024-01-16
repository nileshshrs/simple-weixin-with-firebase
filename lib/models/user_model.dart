// lib/models/user_model.dart
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

  @override
  String toString() {
    return 'UserModel{id: $id, username: $username, email: $email, createdAt: $createdAt, image: $image}';
  }
}
