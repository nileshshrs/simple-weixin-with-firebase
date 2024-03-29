
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:weixin/models/user_model.dart';
import 'package:weixin/viewmodels/login_view_model.dart';


class UserProfilePage extends StatefulWidget {
  static const String routeName = '/userprofile';

  const UserProfilePage();

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late TextEditingController _usernameController;
  bool _isEditing = false;
  ImagePicker picker=ImagePicker();
  // FirebaseStorage storage= FirebaseStorage.instance;
  File? image;
  String? url;



  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }
  void pickImage(ImageSource source) async {
    var selected = await picker.pickImage(source: source, imageQuality: 100);
    if (selected == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("No image selected")));
    } else {
      setState(() {
        image = File(selected.path);
        saveToStorage();
      });
    }
  }

  void saveToStorage() async {
    try {
      if (image == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No image selected")));
        return;
      }

      // Generate a unique image name using timestamp and a random string
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String randomString = '${DateTime.now().microsecondsSinceEpoch}${Random().nextInt(1000)}';
      String name = '$timestamp-$randomString.jpg';

      Reference storageReference = FirebaseStorage.instance.ref().child('images/$name');

      // Upload the file to Firebase Storage
      await storageReference.putFile(File(image!.path));

      // Get the download URL
      String tempUrl = await storageReference.getDownloadURL();
      print("download url:::${tempUrl}");
      // Update the profile picture URL in LoginViewModel
      await LoginViewModel().updateProfilePicture(tempUrl);

      setState(() {
        url = tempUrl;
      });

      print('Image URL updated in SharedPreferences: $tempUrl');
    } catch (error) {
      print('Error uploading image to Firebase Storage: $error');
    }
  }




  Future<void> _toggleEditing(UserModel user) async {
    setState(() {
      _isEditing = !_isEditing;
      if (_isEditing) {
        _usernameController.text = user.username;
      } else {
        // Save the updated username
        String newUsername = _usernameController.text;

        // Update the username in Firestore
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        CollectionReference users = firestore.collection('users');

        // Assuming 'userId' is the unique identifier for each user
        String userId = user.id;

        users.doc(userId).update({
          'username': newUsername,
        }).then((value) async {
          print('Username updated successfully');

          // Update the username in SharedPreferences
          await LoginViewModel().updateUsername(newUsername);

          // Update the username in chat rooms
          await _updateChatRoomUsernames(user.username, newUsername);

          // Trigger a rebuild of the UI
          setState(() {});
        }).catchError((error) {
          print('Failed to update username: $error');
        });
      }
    });
  }

  Future<void> _updateChatRoomUsernames(String oldUsername, String newUsername) async {
    try {
      // Update the username in chat rooms
      CollectionReference chatRooms = FirebaseFirestore.instance.collection('chat_rooms');
      QuerySnapshot userChatRooms = await chatRooms.where('user_names', arrayContains: oldUsername).get();

      for (QueryDocumentSnapshot doc in userChatRooms.docs) {
        // Update the sender's name in the messages sub-collection
        String chatRoomId = doc.id;
        await chatRooms
            .doc(chatRoomId)
            .collection('messages')
            .where('sender', isEqualTo: oldUsername)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((messageDoc) async {
            await chatRooms
                .doc(chatRoomId)
                .collection('messages')
                .doc(messageDoc.id)
                .update({'sender': newUsername});
          });
        });

        // Update the username in the chat room's user_names field
        List<String> userNames = List.from(doc['user_names'] ?? []);
        userNames.remove(oldUsername);
        userNames.add(newUsername);

        await chatRooms.doc(chatRoomId).update({
          'user_names': userNames,
        });
      }

      print('Chat room usernames and sender names updated successfully.');
    } catch (error) {
      print('Error updating chat room usernames and sender names: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: LoginViewModel().getUserDataFromPreferences(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Text('No user data available');
        }

        UserModel user = snapshot.data!;

        return Scaffold(
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 0),
            color: Color(0xFFEDEDED),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 32,
                    child: Container(
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    height: 140,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: Colors.white,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Builder(
                          builder: (context) {
                            print("IMAGE:::::::::${user.image}");
                            return Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                  image: NetworkImage(user.image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  _isEditing
                                      ? Expanded(
                                    child: TextField(
                                      controller: _usernameController,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      decoration: InputDecoration(
                                        focusedBorder:
                                        UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.green,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.zero,
                                        isDense: true,
                                      ),
                                    ),
                                  )
                                      : Text(
                                    user.username,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  IconButton(
                                    icon: _isEditing
                                        ? Icon(Icons.done)
                                        : Icon(Icons.edit),
                                    onPressed: () => _toggleEditing(user),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Email: ${user.email}',
                                style: TextStyle(fontSize: 13),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'ID: ${user.id}',
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
                        'Created at: ${DateFormat('yyyy-MM-dd').format(user.createdAt)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF191970),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    height: 60,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle button press
                        pickImage(ImageSource.gallery);
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 8),
                          Text(
                            'Change Picture',
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
        );
      },
    );
  }
}
