import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
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
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      String uid = userCredential.user!.uid;
      print("user id is $uid");

      UserModel? user = await _userRepository.getUserByEmail(email.trim());

      if (user != null) {
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
    try {
      return UserModel(
        id: prefs.getString('userId') ?? '',
        username: prefs.getString('username') ?? '',
        email: prefs.getString('email') ?? '',
        createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').parse(prefs.getString('createdAt') ?? ''),
        image: prefs.getString('image') ?? '',
      );
    } catch (e) {
      print('Error parsing date: $e');
      return null;
    }
  }

  Future<bool> updateUsername(String newUsername) async {
    try {
      UserModel? user = await getUserDataFromPreferences();

      if (user != null) {
        // Create a new instance of UserModel with the updated username
        UserModel updatedUser = UserModel(
          id: user.id,
          username: newUsername,
          email: user.email,
          createdAt: user.createdAt,
          image: user.image,
        );

        // Update the username in SharedPreferences
        await _saveUserDataToPreferences(updatedUser);

        // Update the username in chat rooms (if applicable)
        // Example: await _updateChatRoomUsernames(user.username, newUsername);

        return true;
      }

      return false;
    } catch (error) {
      print('Error updating username: $error');
      return false;
    }
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

  Future<bool> updateProfilePicture(String newImageUrl) async {
    try {
      UserModel? user = await getUserDataFromPreferences();

      if (user != null) {
        // Create a new instance of UserModel with the updated image URL
        UserModel updatedUser = UserModel(
          id: user.id,
          username: user.username,
          email: user.email,
          createdAt: user.createdAt,
          image: newImageUrl, // Update the image field with the new URL
        );

        final FirebaseFirestore _firestore = FirebaseFirestore.instance;
        _firestore.collection('users').doc(user.id).update({"image":newImageUrl});




        // Update the image URL in SharedPreferences
        await _saveUserDataToPreferences(updatedUser);

        return true;
      }

      return false;
    } catch (error) {
      print('Error updating profile picture: $error');
      return false;
    }
  }
  Future<bool> checkLoggedIn() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      // If userId is not null, consider the user as logged in
      return userId != null;
    } catch (error) {
      print('Error checking user status: $error');
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
