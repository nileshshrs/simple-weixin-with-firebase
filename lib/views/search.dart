import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'profile_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);
  static const String routeName = "/search";

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  StreamController<List<DocumentSnapshot>> _streamController =
  StreamController<List<DocumentSnapshot>>();

  @override
  void dispose() {
    _searchController.dispose();
    _streamController.close();
    super.dispose();
  }

  void performSearch(String query) {
    if (query.isEmpty) {
      // If the query is empty, clear the search results
      _streamController.add([]);
    } else {
      String lowerCaseQuery = query.toLowerCase();
      _streamController.add([]);

      FirebaseFirestore.instance
          .collection('users')
          .where('email', isGreaterThanOrEqualTo: lowerCaseQuery)
          .where('email', isLessThan: lowerCaseQuery + 'z')
          .limit(10)
          .snapshots()
          .listen((QuerySnapshot querySnapshot) {
        _streamController.add(querySnapshot.docs);
      });
    }
  }

  void navigateToProfilePage(String username, String email, String id, String image, Timestamp createdAt) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(
          username: username,
          email: email,
          id: id,
          image: image,
          createdAt: createdAt,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          padding: EdgeInsets.only(bottom: 4, top: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.grey),
              SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (query) => performSearch(query),
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search...',
                    isDense: true,
                    contentPadding: EdgeInsets.all(0),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          SizedBox(width: 4),
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
        backgroundColor: Color(0xFFededed),
        elevation: 1,
        bottom: PreferredSize(
          child: Container(
            color: Colors.grey[300],
            height: 1.0,
          ),
          preferredSize: Size.fromHeight(1.0),
        ),
      ),
      body: StreamBuilder<List<DocumentSnapshot>>(
        stream: _streamController.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text(
                'No search results',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          List<DocumentSnapshot> searchResults = snapshot.data!;

          if (searchResults.isEmpty) {
            return Center(
              child: Text(
                'No search results',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              DocumentSnapshot user = searchResults[index];
              return ListTile(
                title: Text(user['username']),
                subtitle: Text(user['email']),
                // onTap: () {
                //   navigateToProfilePage(
                //     user['username'],
                //     user['email'],
                //     user['id'],
                //     user['image'],
                //     user['created at']
                //   );
                // },
              );
            },
          );
        },
      ),
    );
  }
}
