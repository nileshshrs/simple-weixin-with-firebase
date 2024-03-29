import 'package:weixin/viewmodels/login_view_model.dart';
import 'package:weixin/viewmodels/registration_view_model.dart';
import 'package:weixin/views/forgot_password_screen.dart';
import 'package:weixin/views/home_screen.dart';
import 'package:weixin/views/registration_screen.dart';
import 'package:weixin/views/login_screen.dart'; // Add the import for LoginScreen
import 'package:weixin/views/search_page.dart';
import 'package:weixin/views/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
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
        ChangeNotifierProvider(create: (context) => LoginViewModel()),

        // Add more providers for other view models or services if needed
      ],
      child: MaterialApp(
        title: 'weixin',
        home: SplashScreen(),
        routes: {
          RegistrationScreen.routeName: (context) => RegistrationScreen(),
          ForgotPasswordScreen.routeName:(context)=>ForgotPasswordScreen(),
          LoginScreen.routeName: (context) => LoginScreen(),
          HomeScreen.routeName: (context) => HomeScreen(),
          SearchPage.routeName: (context) => SearchPage(),// Add this line for the LoginScreen route
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
