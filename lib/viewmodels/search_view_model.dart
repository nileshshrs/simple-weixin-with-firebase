// lib/viewmodels/search_view_model.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class SearchViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final StreamController<List<UserModel>> _streamController =
  StreamController<List<UserModel>>();

  Stream<List<UserModel>> get searchResults => _streamController.stream;

  void performSearch(String query) async {
    if (query.isEmpty) {
      _streamController.add([]);
    } else {
      try {
        _setLoading(true);

        String lowerCaseQuery = query.toLowerCase();

        var snapshot = await _firestore
            .collection('users')
            .where('email', isGreaterThanOrEqualTo: lowerCaseQuery)
            .where('email', isLessThan: lowerCaseQuery + 'z')
            .limit(10)
            .get();

        List<UserModel> results = snapshot.docs
            .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList();

        _streamController.add(results);
      } catch (e) {
        print('Error performing search: $e');
        _streamController.addError('Error performing search');
      } finally {
        _setLoading(false);
      }
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
