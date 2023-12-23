import 'package:flutter/material.dart';
import 'package:firebase_chat_application/pages/home.dart';

class ProfilePage extends StatefulWidget {
  final String username;
  final String email;

  const ProfilePage({
    Key? key,
    required this.username,
    required this.email,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, Home.routeName);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile: ${widget.username}'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Username: ${widget.username}'),
              Text('Email: ${widget.email}'),
            ],
          ),
        ),
      ),
    );
  }
}
