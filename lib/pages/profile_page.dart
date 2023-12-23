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
    Map<String, String?> userData = await SharedPreferencesService.getUserData();

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
        body: Container(
          padding: EdgeInsets.only(bottom: 20), // Add padding to the bottom of the container
          color: Color(0xFFEDEDED), // Set the background color of the whole page
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 140, // Increased height to accommodate additional spacing
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Add padding to the left, right, and top sides
                  color: Colors.white, // Set the background color of the container
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                            image: NetworkImage(widget.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 16), // Add a bit of spacing between the image and text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8), // Add a bit of spacing between the top and username
                            Text(
                              widget.username,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4), // Add a bit of spacing between username and email
                            Text(
                              'Email: ${widget.email}',
                              style: TextStyle(fontSize: 13),
                            ),
                            SizedBox(height: 4), // Add a bit of spacing between email and ID
                            Text(
                              'ID: ${widget.id}',
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  height:60,
                  color: Colors.white, // Set the background color of the container
                  child: Center(
                    child: Text(
                      'Created at: ${DateFormat('yyyy-MM-dd').format(widget.createdAt.toDate())}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF191970)),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  height: 60, // Set the height of the button container to match the "Send Message" container
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: ElevatedButton(
                    onPressed: _sendMessage,
                    style: ElevatedButton.styleFrom(
                      elevation: 0, // Set elevation to 0 to make it flat
                      primary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero, // Set borderRadius to zero for a rectangular shape
                      ),// Set button background color
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          IconData(0xf3fb, fontFamily: 'CupertinoIcons', fontPackage: 'cupertino_icons'),
                          color: Colors.green, // Set icon color to white
                        ),
                        SizedBox(width: 8), // Add spacing between icon and text
                        Text(
                          'Send Message',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 18,
                            fontWeight: FontWeight.w500// Set text color to white
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
      ),
    );
  }
}