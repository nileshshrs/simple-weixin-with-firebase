import 'package:firebase_chat_application/repositories/chat_repository.dart';
import 'package:firebase_chat_application/views/chat_screen.dart';
import 'package:firebase_chat_application/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user_model.dart';
import '../viewmodels/profile_view_model.dart';
import '../viewmodels/login_view_model.dart'; // Import LoginViewModel

class ProfilePage extends StatefulWidget {
  final String userId;

  const ProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileViewModel _profileViewModel;
  late LoginViewModel _loginViewModel; // Instantiate LoginViewModel
  late ChatRepository _chatRepository;
  String? loggedInUserId;
  String ? loggedInUsername;
  @override
  void initState() {
    super.initState();
    _profileViewModel = ProfileViewModel();
    _loginViewModel = LoginViewModel();
    _chatRepository = ChatRepository();// Initialize LoginViewModel
    _loadUserData();
  }

  // Create a separate method to load user data asynchronously
  Future<void> _loadUserData() async {
    try {
      await _profileViewModel.loadUserData(widget.userId);

      // Access the loaded user data and print it
      if (_profileViewModel.user != null) {
        print('Loaded user data: ${_profileViewModel.user}');
      } else {
        print('Error loading user data.');
      }

      // Trigger a rebuild of the widget tree after loading user data
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '${_profileViewModel.user?.username ?? ''}',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 1,
        ),
        body: Container(
          padding: EdgeInsets.only(bottom: 20),
          color: Color(0xFFEDEDED),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 140,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.white,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          image:
                              _profileViewModel.user?.image.isNotEmpty ?? false
                                  ? DecorationImage(
                                      image: NetworkImage(
                                          _profileViewModel.user?.image ?? ''),
                                      fit: BoxFit.cover,
                                    )
                                  : null, // Null if the image URL is empty
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            Text(
                              _profileViewModel.user?.username ?? '',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Email: ${_profileViewModel.user?.email ?? ''}',
                              style: TextStyle(fontSize: 13),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'ID: ${_profileViewModel.user?.id ?? ''}',
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
                  height: 60,
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      'Created at: ${DateFormat('yyyy-MM-dd').format(_profileViewModel.user?.createdAt ?? DateTime.now())}',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF191970)),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  height: 60,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: ElevatedButton(
                    onPressed: () async {
                      String receiverId = _profileViewModel.user?.id ?? '';
                      String receiverUsername =
                          _profileViewModel.user?.username ?? '';

                      // Print the user data from LoginViewModel
                      UserModel? user =
                          await _loginViewModel.getUserDataFromPreferences();
                      loggedInUserId = user?.id;
                      loggedInUsername = user?.username;

                      print('$receiverId,$receiverUsername');
                      print('logged in user, ${loggedInUserId}, ${loggedInUsername}');
                      String chatroomId = await _chatRepository.createChatRoom(loggedInUserId, loggedInUsername, receiverId, receiverUsername);
                      // Rest of your code...
                      print(chatroomId);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatRoomPage(chatRoomId: chatroomId),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          IconData(0xf3fb,
                              fontFamily: 'CupertinoIcons',
                              fontPackage: 'cupertino_icons'),
                          color: Color(0xFF3EB575),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Send Message',
                          style: TextStyle(
                            color: Color(0xFF3EB575),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
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
