// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:login_page/home_page.dart';
import 'package:login_page/login_page.dart';
import 'package:login_page/sign_up.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Login Page",
      debugShowCheckedModeBanner: false,
      initialRoute: LoginPage.path,
      routes: {
        LoginPage.path: (context) => LoginPage(),
        HomePage.path: (context) => HomePage(),
        SignUp.path: (context) => SignUp()
      },
    );
  }
}
