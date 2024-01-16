// lib/repositories/profile_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class ProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> getUserById(String userId) async {
    try {
      var snapshot = await _firestore.collection('users').doc(userId).get();

      if (snapshot.exists) {
        var userData = snapshot.data();
        return UserModel(
          id: userData!['id'],
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
