
import 'package:firebase_chat_application/viewmodels/registration_view_model.dart';
import 'package:firebase_chat_application/views/registration_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RegistrationViewModel()),
        // Add more providers for other view models or services if needed
      ],
      child: MaterialApp(
        title: 'Your Chat App',

        home: RegistrationScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}