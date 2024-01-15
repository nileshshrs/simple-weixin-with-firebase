// lib/views/registration_screen.dart
import 'package:firebase_chat_application/utils/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_chat_application/viewmodels/registration_view_model.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  void _showFlushbar(BuildContext context, String message, bool isSuccess) {
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
      messageText: Text(
        message,
        style: TextStyle(
          color: isSuccess ? Color(0xFF3EB575) : Colors.red,
        ),
      ),
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
                  child: ChangeNotifierProvider(
                    create: (context) => RegistrationViewModel(),
                    child: Consumer<RegistrationViewModel>(
                      builder: (context, model, child) {
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Register",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                "Create a new account",
                                style: TextStyle(
                                  color: Color(0xFF3EB575),
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
                                  width:
                                  MediaQuery.of(context).size.width - 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: _usernameController,
                                        decoration: InputDecoration(
                                          labelText: 'Username',
                                          labelStyle: TextStyle(
                                            color: Colors.black38,
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xFF3EB575),
                                                width: 2.0),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xFF3EB575),
                                                width: 2.0),
                                          ),
                                          suffixIcon: Icon(
                                            Icons.person,
                                            color: Color(0xFF3EB575),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null ||
                                              value.isEmpty) {
                                            return 'Please enter your username';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: 16),
                                      TextFormField(
                                        controller: _emailController,
                                        decoration: InputDecoration(
                                          labelText: 'Email',
                                          labelStyle: TextStyle(
                                            color: Colors.black38,
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xFF3EB575),
                                                width: 2.0),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xFF3EB575),
                                                width: 2.0),
                                          ),
                                          suffixIcon: Icon(
                                            Icons.email,
                                            color: Color(0xFF3EB575),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null ||
                                              value.isEmpty) {
                                            return 'Please enter your email';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: 16),
                                      TextFormField(
                                        controller: _passwordController,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          labelText: 'Password',
                                          labelStyle: TextStyle(
                                            color: Colors.black38,
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xFF3EB575),
                                                width: 2.0),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xFF3EB575),
                                                width: 2.0),
                                          ),
                                          suffixIcon: GestureDetector(
                                            onTap: () {
                                              // Toggle visibility of the password
                                            },
                                            child: Icon(
                                              Icons.visibility,
                                              color: Color(0xFF3EB575),
                                            ),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null ||
                                              value.isEmpty) {
                                            return 'Please enter your password';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: 16),
                                      TextFormField(
                                        controller:
                                        _confirmPasswordController,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          labelText: 'Confirm Password',
                                          labelStyle: TextStyle(
                                            color: Colors.black38,
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xFF3EB575),
                                                width: 2.0),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xFF3EB575),
                                                width: 2.0),
                                          ),
                                          suffixIcon: GestureDetector(
                                            onTap: () {
                                              // Toggle visibility of the confirm password
                                            },
                                            child: Icon(
                                              Icons.visibility,
                                              color: Color(0xFF3EB575),
                                            ),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null ||
                                              value.isEmpty) {
                                            return 'Please confirm your password';
                                          } else if (value !=
                                              _passwordController.text) {
                                            return 'Passwords do not match';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: 30),
                                      SizedBox(
                                        width: double.infinity,
                                        child: OutlinedButton(
                                          onPressed: () async {
                                            LoadingDialog.showLoadingDialog(
                                                context, "Registering...");

                                            bool success = await model
                                                .registerUser(
                                              username:
                                              _usernameController.text
                                                  .trim(),
                                              email: _emailController.text
                                                  .trim(),
                                              password:
                                              _passwordController.text
                                                  .trim(),
                                              confirmPassword:
                                              _confirmPasswordController
                                                  .text
                                                  .trim(),
                                            );

                                            LoadingDialog.hideLoadingDialog(
                                                context);

                                            if (success) {
                                              _showFlushbar(
                                                  context,
                                                  "Registration successful",
                                                  true);
                                              // Registration successful, navigate or perform other actions
                                            } else {
                                              _showFlushbar(
                                                  context,
                                                  "Registration failed",
                                                  false);
                                              // Registration failed, handle accordingly
                                            }
                                          },
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor:
                                            Color(0xFF3EB575),
                                            side: BorderSide(
                                              color: Colors.white,
                                              width: 1.0,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(8.0),
                                            ),
                                          ),
                                          child: Text(
                                            "Register",
                                            style:
                                            TextStyle(color: Colors.white),
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
                                    Navigator.pop(context);
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Already have an account?",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        "Login",
                                        style: TextStyle(
                                          color: Color(0xFF3EB575),
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
                        );
                      },
                    ),
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
