import 'package:firebase_chat_application/pages/chat_list_page.dart';
import 'package:firebase_chat_application/pages/contact_page.dart';
import 'package:firebase_chat_application/pages/search.dart';
import 'package:firebase_chat_application/pages/signin.dart';
import 'package:firebase_chat_application/services/sharedpreferences_service.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static const String routeName = "/home";

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;
  late Widget currentPage;

  @override
  void initState() {
    super.initState();
    // Set the initial page
    currentPage = const ChatListPage();
  }

  // Function to handle logout
  Future<void> _logout() async {
    // Clear user data from shared preferences
    await SharedPreferencesService.clearUserData();

    // Navigate to the login screen
    Navigator.pushReplacementNamed(context, Signin.routeName);
  }

  @override
  Widget build(BuildContext context) {
    // Custom color that is very subtle off-white
    Color customLightGrey = Color(0xFFFFFCFC);

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Weixin')),
        backgroundColor: customLightGrey,
        elevation: 1,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Handle search button press
              Navigator.pushReplacementNamed(context, SearchPage.routeName);
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: currentPage,
      bottomNavigationBar: BottomNavigationBar(
        elevation: 3,
        backgroundColor: customLightGrey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(IconData(0xf3fb,
                fontFamily: 'CupertinoIcons', fontPackage: 'cupertino_icons')),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Contact',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });

          // Handle navigation based on index
          switch (index) {
            case 0:
              currentPage = const ChatListPage();
              break;
            case 1:
              currentPage = const ContactPage();
              break;
            default:
              currentPage = const SizedBox.shrink();
              break;
          }
        },
      ),
    );
  }
}
