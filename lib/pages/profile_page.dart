import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_application/services/sharedpreferences_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_chat_application/pages/home.dart';
import 'chat_screen.dart'; // Import the ChatScreen
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  final String username;
  final String email;
  final String id;
  final String image;
  final Timestamp createdAt;

  const ProfilePage(
      {Key? key,
      required this.username,
      required this.email,
      required this.id,
      required this.image,
      required this.createdAt})
      : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void _sendMessage() async {
    Map<String, String?> userData =
        await SharedPreferencesService.getUserData();

    print(userData);
    // Navigate to the ChatScreen when the "Send Message" button is tapped
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          // Pass necessary parameters to identify the recipient
          recipientUsername: widget.username,
          recipientEmail: widget.email,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, Home.routeName);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.username}'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('id: ${widget.id}'),
              Text('Username: ${widget.username}'),
              Text('Email: ${widget.email}'),
              Text(
                  'created at: ${DateFormat('yyyy-MM-dd').format(widget.createdAt.toDate())}'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _sendMessage,
                child: Text('Send Message'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
