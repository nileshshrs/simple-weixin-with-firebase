import 'package:flutter/material.dart';
import 'package:firebase_chat_application/pages/signin.dart';
import 'package:firebase_chat_application/pages/register.dart';
import 'package:firebase_chat_application/pages/chat_list_page.dart';
import 'package:firebase_chat_application/pages/contact_page.dart';

class RouteGenerator {
  static const String signinRoute = '/signin';
  static const String registrationRoute = '/registration';
  static const String chatListRoute = '/chatList';
  static const String contactRoute = '/contact';

  static Route<dynamic>? onGenerate(RouteSettings settings) {
    final arg = settings.arguments;

    switch (settings.name) {
      case signinRoute:
        return MaterialPageRoute(builder: (_) => const Signin());

      case registrationRoute:
        return MaterialPageRoute(builder: (_) => const Registration());

      case chatListRoute:
        return MaterialPageRoute(builder: (_) => const ChatListPage());

      case contactRoute:
        return MaterialPageRoute(builder: (_) => const ContactPage());

      default:
        return _onPageNotFound();
    }
  }

  static Route<dynamic> _onPageNotFound() {
    return MaterialPageRoute(builder: (_) => const Scaffold(body: Text("Page not Found")));
  }
}
