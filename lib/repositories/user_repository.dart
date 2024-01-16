// lib/repositories/user_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

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

  Future<UserModel?> getUserByEmail(String email) async {
    try {
      var snapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var userData = snapshot.docs.first.data();
        return UserModel(
          id: userData['id'],
          username: userData['username'],
          email: userData['email'],
          createdAt: (userData['createdAt'] as Timestamp).toDate(),
          image: userData['image'],
        );
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }

    return null;
  }
}
