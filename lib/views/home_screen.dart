import 'package:weixin/viewmodels/login_view_model.dart';
import 'package:weixin/views/UserProfile_screen.dart';
import 'package:weixin/views/chat_list_page.dart';
import 'package:weixin/views/login_screen.dart';
import 'package:weixin/views/search_page.dart';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  late Widget currentPage;

  @override
  void initState() {
    super.initState();
    // Set the initial page
    currentPage = ChatListView();
  }

  // Function to handle logout
  Future<void> _logout() async {
    try {
      // Access your LoginViewModel or wherever you have the logout logic
      // Assuming you have an instance of LoginViewModel
      LoginViewModel loginViewModel = LoginViewModel();

      // Clear user data from shared preferences
      await loginViewModel.clearUserDataFromPreferences();

      // Navigate to the login screen
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    } catch (error) {
      print('Logout failed: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Custom color that is very subtle off-white
    Color customLightGrey = Color(0xFFFFFCFC);
    Color selectedIconColor = Color(0xFF3EB575);

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Weixin', style: TextStyle(color: Colors.black))),
        backgroundColor: customLightGrey,
        elevation: 1,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // Handle search button press
              Navigator.pushReplacementNamed(context, SearchPage.routeName);
            },
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.black),
            onPressed: () {
              _logout();
              // Handle logout button press
              // You can implement your logic here
            },
          ),
        ],
      ),
      body: currentPage,
      bottomNavigationBar: BottomNavigationBar(
        elevation: 3,
        backgroundColor: customLightGrey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              IconData(0xf3fb,
                  fontFamily: 'CupertinoIcons', fontPackage: 'cupertino_icons'),
              color: selectedIndex == 0 ? selectedIconColor : Colors.black,
            ),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: selectedIndex == 1 ? selectedIconColor : Colors.black,
            ),
            label: 'Me',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: selectedIconColor, // Selected icon color
        unselectedItemColor: Colors.black,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });

          // Handle navigation based on index
          switch (index) {
            case 0:
              currentPage = ChatListView();
              break;
            case 1:
              currentPage = const UserProfilePage();
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
