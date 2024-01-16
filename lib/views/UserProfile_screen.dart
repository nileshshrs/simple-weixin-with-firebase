import 'package:firebase_chat_application/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_chat_application/services/sharedpreferences_service.dart';
import 'package:firebase_chat_application/viewmodels/login_view_model.dart';

class UserProfilePage extends StatelessWidget {
  static const String routeName = '/userprofile';

  const UserProfilePage();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: LoginViewModel().getUserDataFromPreferences(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // or some loading indicator
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Text('No user data available');
        }

        // User details from SharedPreferences
        UserModel user = snapshot.data!;

        return Scaffold(
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 0),
            color: Color(0xFFEDEDED),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // User details container
                  SizedBox(
                    height: 32,
                    child: Container(
                      color: Colors.white,
                      // ... (rest of your code)
                    ),
                  ),
                  Container(
                    height: 140,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: Colors.white,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                              image: NetworkImage(user.image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 16,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              Text(
                                user.username,
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Email: ${user.email}',
                                style: TextStyle(fontSize: 13),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'ID: ${user.id}',
                                style: TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  // Created at container
                  Container(
                    height: 60,
                    color: Colors.white,
                    child: Center(
                      child: Text(
                        'Created at: ${DateFormat('yyyy-MM-dd').format(user.createdAt)}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF191970)),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  // Send Message button container
                  Container(
                    height: 60,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle button press
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 8),
                          Text(
                            'Edit Profile',
                            style: TextStyle(
                              color: Color(0xFF3EB575),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
