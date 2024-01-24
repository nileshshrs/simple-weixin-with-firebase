import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_chat_application/views/home_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "/splash";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate a delay using Timer
    // Timer(Duration(seconds: 2), () {
    //   // Replace 'HomeScreen.routeName' with your actual main screen route
    //   Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    // });
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
