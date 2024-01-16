import 'package:flutter/material.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'This is the Chat List Page',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
