// lib/viewmodels/registration_view_model.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_application/repositories/user_repository.dart';

class RegistrationViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserRepository _userRepository = UserRepository();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<bool> registerUser({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      return false;
    }

    try {
      _setLoading(true); // Set loading to true before the registration

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      await _userRepository.registerUser(
        userId: userCredential.user!.uid,
        username: username.trim(),
        email: email.trim(),
        createdAt: DateTime.now(),
        image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQiUKap2O1u-ulRZ8icnJXKFmL5d4NuVBX6goF1ZGvwUw&s",
      );

      // Registration successful, you can return user data or perform other actions
      return true;
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Error: ${e.message}");
      return false;
    } finally {
      _setLoading(false); // Set loading to false after registration, whether it succeeds or fails
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
