import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";
  const HomeScreen({Key? key}) : super(key: key);

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
    currentPage = const ChatListPage();
  }

  // Function to handle logout
  Future<void> _logout() async {
    // Implement logout logic
    // For example, clear user data from shared preferences and navigate to the login screen
  }

  @override
  Widget build(BuildContext context) {
    // Custom color that is very subtle off-white
    Color customLightGrey = Color(0xFFFFFCFC);

    return Scaffold(
      appBar: selectedIndex == 1
          ? null // Hide the AppBar when on the Profile page
          : AppBar(
        title: Center(child: Text('Your App Name')),
        backgroundColor: customLightGrey,
        elevation: 1,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Handle search button press
              // For example, navigate to the search page
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
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.green, // Adjust the color as needed
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

class ChatListPage extends StatelessWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Chat List Page'),
    );
  }
}

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('User Profile Page'),
    );
  }
}
