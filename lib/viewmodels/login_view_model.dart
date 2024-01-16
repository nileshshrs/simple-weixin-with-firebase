// lib/viewmodels/login_view_model.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserRepository _userRepository = UserRepository();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      // print(email);
      // print(password);
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      String uid = userCredential.user!.uid;
      print("user id is $uid");
      // return true;
      // // Fetch user data from Firestore using email
      UserModel? user = await _userRepository.getUserByEmail(email.trim());

      if (user != null) {
        // Save user data to SharedPreferences
        await _saveUserDataToPreferences(user);

        return true;
      } else {
        return false;
      }
    } catch (error) {
      print('Login failed: $error');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  Future<UserModel?> getUserDataFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return UserModel(
      id: prefs.getString('userId') ?? '',
      username: prefs.getString('username') ?? '',
      email: prefs.getString('email') ?? '',
      createdAt: DateTime.parse(prefs.getString('createdAt') ?? ''),
      image: prefs.getString('image') ?? '',
    );
  }
  Future<void> _saveUserDataToPreferences(UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', user.id);
    prefs.setString('username', user.username);
    prefs.setString('email', user.email);
    prefs.setString('createdAt', user.createdAt.toString());
    prefs.setString('image', user.image);
  }
  Future<void> clearUserDataFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
