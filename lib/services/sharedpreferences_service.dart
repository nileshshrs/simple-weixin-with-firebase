import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static Future<void> saveUserData(String userID, String username, String email,
      DateTime createdAt, String image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Format createdAt as a string
    String formattedCreatedAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(createdAt);

    // Store user data in shared preferences
    prefs.setString('id', userID);
    prefs.setString('username', username);
    prefs.setString('email', email);
    prefs.setString('created at', formattedCreatedAt);
    prefs.setString('image', image);
  }

  static Future<Map<String, String?>> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve user data from shared preferences
    String? id = prefs.getString('id');
    String? username = prefs.getString('username');
    String? email = prefs.getString('email');
    String? created = prefs.getString('created at');
    String? image = prefs.getString('image');

    return {'id': id, 'username': username, 'email': email, 'created at': created, 'image': image};
  }

  static Future<void> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print("Clearing user data from storage");
  }
}
