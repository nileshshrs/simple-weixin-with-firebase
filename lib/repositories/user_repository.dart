import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerUser({
    required String userId,
    required String username,
    required String email,
    required DateTime createdAt,
    required String image,
  }) async {
    await _firestore.collection('users').doc(userId).set({
      'id': userId,
      'username': username,
      'email': email,
      'createdAt': createdAt,
      'image': image,
    });
  }
}