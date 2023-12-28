import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_chat_application/pages/home.dart';
import 'package:firebase_chat_application/services/auth_service.dart';
import 'package:firebase_chat_application/services/sharedpreferences_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_chat_application/pages/register.dart';

class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);
  static const String routeName = "/login";

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  bool _isPasswordVisible = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  AuthService _authService = AuthService();

  Future<void> _login() async {
    try {
      String uid = await _authService.login(
        email: _emailController.text,
        password: _passwordController.text,
      );
      print("fetching the saved user credentials from storage");
      Map<String, String?> userData = await SharedPreferencesService.getUserData();

      print(userData) ;
      print("fetched userdata succesfully from the storage");
      print('User logged in successfully:');
      // Navigate to the home screen or any other screen
      // print('Login successful! User UID: $uid');
      Navigator.pushReplacementNamed(context, Home.routeName);
    } catch (error) {
      // Handle errors, show messages, etc.
      print('Login failed: $error');
      _showFlushbar("Incorrect email or password", false);
    }
  }
  void _showFlushbar(String message, bool isSuccess) {
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
                    colors: [Color(0xFF4BAD4F), Color(0xFF4BAD4F)],
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
                      SizedBox(height: 20),
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
                                      color: Color(0xFF4BAD4F),
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
                                          labelText: 'email',
                                          labelStyle: TextStyle(
                                            color: Colors.black38,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    Icon(Icons.email, color: Color(0xFF4BAD4F)),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              SizedBox(height: 20),
                              Container(
                                padding: EdgeInsets.only(left: 10.0, right: 10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Color(0xFF4BAD4F),
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _passwordController,
                                        obscureText: !_isPasswordVisible,
                                        decoration: InputDecoration(
                                          labelText: 'password',
                                          labelStyle: TextStyle(
                                            color: Colors.black38,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isPasswordVisible =
                                              !_isPasswordVisible;
                                        });
                                      },
                                      child: Icon(
                                        _isPasswordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Color(0xFF4BAD4F),
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
                                    color: Color(0xFF4BAD4F),
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 30),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () {
                                    _login();
                                    // Print the username and password
                                    print("Username: ${_emailController.text}");
                                    print(
                                        "Password: ${_passwordController.text}");
                                  },
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Color(0xFF4BAD4F),
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
                                context, Registration.routeName);
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
                                  color: Color(0xFF4BAD4F),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
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
            ],
          ),
        ),
      ),
    );
  }
}
