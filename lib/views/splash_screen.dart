import 'dart:async';
import 'package:firebase_chat_application/viewmodels/login_view_model.dart';
import 'package:firebase_chat_application/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_chat_application/views/home_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "/splash";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    // Simulate a delay of 5 seconds
    await Future.delayed(Duration(seconds: 5));

    // Check user status and navigate accordingly
    _checkUserStatus();
  }

  Future<void> _checkUserStatus() async {
    LoginViewModel loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    bool isLoggedIn = await loginViewModel.checkLoggedIn();

    if (isLoggedIn) {
      // User is logged in, navigate to the home screen
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    } else {
      // User is not logged in, navigate to the login screen
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Your splash screen content, like logo or image
              Image.asset(
                'assets/2.jpg', // Replace with your image asset path
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
