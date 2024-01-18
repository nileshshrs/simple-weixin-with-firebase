// lib/views/search_page.dart
import 'dart:async';
import 'package:firebase_chat_application/views/profile_page.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../viewmodels/search_view_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);
  static const String routeName = "/search";

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  late SearchViewModel _searchViewModel;

  @override
  void initState() {
    super.initState();
    _searchViewModel = SearchViewModel();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                  cursorColor: Colors.green,
                  controller: _searchController,
                  onChanged: (query) => _searchViewModel.performSearch(query),
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
      body: StreamBuilder<List<UserModel>>(
        stream: _searchViewModel.searchResults,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No search results'));
          }

          List<UserModel> searchResults = snapshot.data!;

          return ListView.builder(
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              UserModel user = searchResults[index];
              return ListTile(
                title: Text(user.username),
                subtitle: Text(user.email),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(userId: user.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
