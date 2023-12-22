import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static Future<void> saveUserData(String userID,String username, String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Store user data in shared preferences
    prefs.setString('id', userID);
    prefs.setString('username', username);
    prefs.setString('email', email);

  }

  static Future<Map<String, String?>> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve user data from shared preferences
    String? id = prefs.getString('id');
    String? username = prefs.getString('username');
    String? email = prefs.getString('email');



    return {'id': id,'username': username, 'email': email};
  }

  static Future<void> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print("clearing user data from the storage");
  }
}