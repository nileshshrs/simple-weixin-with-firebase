import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:another_flushbar/flushbar.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _showFlushbar(BuildContext context, String message, bool isSuccess) {
    if (isSuccess) {
      // If password reset email is sent successfully, show success Flushbar
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
        messageColor: Colors.green,
      )..show(context);
    } else {
      // If an error occurred, show error Flushbar
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
        messageColor: Colors.red,
      )..show(context);
    }
  }

  Future<void> _resetPassword() async {
    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text);
      // Password reset email sent successfully
      print("Password reset email sent successfully!");

      // Clear the email TextField
      _emailController.clear();

      // Show success Flushbar
      _showFlushbar(context, 'Password reset email sent successfully! Please login.', true);
    } catch (e) {
      // An error occurred. Handle the error appropriately.
      print("Error sending password reset email: $e");

      // Show error Flushbar
      _showFlushbar(context, 'Error sending password reset email', false);
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
                        "Forgot Password",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
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
                              SizedBox(height: 30),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: _resetPassword,
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
                                    "Reset Password",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            // Navigate back to the login page
                            Navigator.pop(context);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Remember your password?",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(height: 12),
                              Text(
                                "Back to Login",
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
