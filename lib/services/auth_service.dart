import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_application/services/sharedpreferences_service.dart';


class AuthService {
  Future<void> signup({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      // Check if the email is already registered
      List<String> signInMethods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

      if (signInMethods.isNotEmpty) {
        // The email is already registered, show an error message
        throw FirebaseAuthException(
          code: 'email-already-in-use',
          message:
              'This email is already registered. Please use a different email.',
        );
      } else {
        // The email is not registered, proceed with registration
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Registration successful
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'id': userCredential.user!.uid,
          'username': username,
          'email': email,
          'created at': FieldValue.serverTimestamp(),
          'image': "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQiUKap2O1u-ulRZ8icnJXKFmL5d4NuVBX6goF1ZGvwUw&s"
        });
      }
    } catch (error) {
      // Handle registration errors
      print("Error during registration: $error");
      throw error; // Rethrow the error so it can be handled in the UI
    }
  }

  Future<String> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      String uid = userCredential.user!.uid;
      await getUserData(email, uid);



      // Return the user UID or any other information if needed
      return userCredential.user!.uid;
    } catch (error) {
      // Handle login errors
      print('Login failed: $error');
      throw error; // Rethrow the error so it can be handled in the UI
    }
  }
  Future<void> getUserData(String email, String uid) async {
    try {
      QuerySnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (userData.docs.isNotEmpty) {
        QueryDocumentSnapshot userDocument = userData.docs.first;
        Map<String, dynamic> user = userDocument.data() as Map<String, dynamic>;

        // Access user data, for example:
        String userID = uid;
        String username = user['username'];
        String userEmail = user['email'];
        Timestamp createdAtTimestamp = user['created at'] as Timestamp;
        DateTime createdAt = createdAtTimestamp.toDate();
        String image = user['image'];

        print("saving user credentials in storage");
        SharedPreferencesService.saveUserData(userID, username, userEmail, createdAt, image);
        print("...");
        print("saved user credentials in storage.");
        // Print user data
        // print('Username: $username');
        // print('Email: $userEmail');
      } else {
        print('User not found for email: $email');
      }
    } catch (error) {
      print("Error fetching user data: $error");
      throw error;
    }
  }
}
