import 'package:firebase_authentication/views/create_account_page.dart';
import 'package:firebase_authentication/views/forgot_password_page.dart';
import 'package:firebase_authentication/views/home_page.dart';
import 'package:firebase_authentication/views/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/home', // Set the initial route
      routes: {
        '/login': (context) => LoginPage(),
        '/create_account': (context) => CreateAccountPage(),
        '/home': (context) => HomePage(), //Add home page
        '/forgot_password': (context) => ForgotPasswordPage()
        // Add other routes as needed
      },
    );
  }
}
