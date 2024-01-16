// lib/views/login_screen.dart
import 'package:firebase_chat_application/models/user_model.dart';
import 'package:firebase_chat_application/views/home_screen.dart';
import 'package:firebase_chat_application/views/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_chat_application/utils/loading_dialog.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_chat_application/viewmodels/login_view_model.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = "/login";
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _showFlushbar(BuildContext context, String message, bool isSuccess) {
    if (isSuccess) {
      // If login is successful, navigate to the HomeScreen directly
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    } else {
      // If not successful, show the Flushbar
      Flushbar(
        message: message,
        duration: Duration(seconds: 5),
        backgroundColor: Colors.white,
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        margin: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
        borderRadius: BorderRadius.circular(10.0),
        boxShadows: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 2.0),
            blurRadius: 3.0,
          ),
        ],
        messageColor: isSuccess ? Colors.green : Colors.red,
      )..show(context);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF3EB575), Color(0xFF3EB575)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.elliptical(
                      MediaQuery.of(context).size.width,
                      105.0,
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 70.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Login to your account",
                        style: TextStyle(
                          color: Color(0xFFBBB0FF),
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 30),
                      Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 30.0,
                            horizontal: 20.0,
                          ),
                          width: MediaQuery.of(context).size.width - 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 30),
                              Container(
                                padding: EdgeInsets.only(left: 10.0, right: 10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Color(0xFF3EB575),
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _emailController,
                                        decoration: InputDecoration(
                                          labelText: 'Email',
                                          labelStyle: TextStyle(
                                            color: Colors.black38,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    Icon(Icons.email, color: Color(0xFF3EB575)),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                padding: EdgeInsets.only(left: 10.0, right: 10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Color(0xFF3EB575),
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _passwordController,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          labelText: 'Password',
                                          labelStyle: TextStyle(
                                            color: Colors.black38,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        // Toggle visibility of the password
                                      },
                                      child: Icon(
                                        Icons.visibility,
                                        color: Color(0xFF3EB575),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 30),
                              GestureDetector(
                                onTap: () {
                                  // Implement the logic for password reset here
                                  // You can navigate to a new screen or show a dialog for password reset
                                  print("Forgot Password tapped!");
                                },
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    color: Color(0xFF3EB575),
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 30),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () async {
                                    LoadingDialog.showLoadingDialog(
                                      context,
                                      "Logging in...",
                                    );

                                    bool success = await context
                                        .read<LoginViewModel>()
                                        .loginUser(
                                          email: _emailController.text.trim(),
                                          password:
                                              _passwordController.text.trim(),
                                        );

                                    LoadingDialog.hideLoadingDialog(context);

                                    if (success) {
                                      _showFlushbar(
                                        context,
                                        "Login successful",
                                        true,
                                      );
                                      UserModel? userData =
                                      await context.read<LoginViewModel>().getUserDataFromPreferences();
                                      print("User Data: $userData");
                                      // Navigate to the home screen or perform other actions
                                    } else {
                                      _showFlushbar(
                                        context,
                                        "Incorrect email or password",
                                        false,
                                      );
                                      // Handle login failure
                                    }
                                  },
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Color(0xFF3EB575),
                                    side: BorderSide(
                                      color: Colors.white,
                                      width: 1.0,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  child: Text(
                                    "Login",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      SizedBox(height: 16),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            // Navigate to the registration page
                            Navigator.pushNamed(
                              context,
                              RegistrationScreen.routeName,
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account?",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(height: 12),
                              Text(
                                "Register",
                                style: TextStyle(
                                    color: Color(0xFF3EB575),
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
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
  }
}
