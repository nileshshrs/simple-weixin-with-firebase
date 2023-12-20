import 'package:firebase_chat_application/Routes/RouteGenerator.dart';
import 'package:firebase_chat_application/pages/chat_list_page.dart';
import 'package:firebase_chat_application/pages/contact_page.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Custom color that is very subtle off-white
    Color customLightGrey = Color(0xFFFFFCFC);

    Widget currentPage;

    switch (selectedIndex) {
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

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Weixin')),
        backgroundColor: customLightGrey, // Custom very subtle off-white color
        elevation: 1, // Adding box shadow
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Handle search button press
            },
          ),
        ],
      ),
      body: currentPage,
      bottomNavigationBar: BottomNavigationBar(
        elevation: 3,
        backgroundColor: customLightGrey, // Set the same background color
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
              Navigator.pushNamed(context, RouteGenerator.chatListRoute);
              break;
            case 1:
              Navigator.pushNamed(context, RouteGenerator.contactRoute);
              break;
            default:
              break;
          }
        },
      ),
    );
  }
}
