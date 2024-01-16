// lib/viewmodels/profile_view_model.dart
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../repositories/profile_repository.dart';

class ProfileViewModel extends ChangeNotifier {

  final ProfileRepository _profileRepository = ProfileRepository();
  UserModel? _user;

  UserModel? get user => _user;

  Future<void> loadUserData(String userId) async {

    try {
      _user = await _profileRepository.getUserById(userId);
      notifyListeners();
    } catch (e) {
      print('Error loading user data: $e');
    }
  }
}
