// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, empty_catches

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:login_page/home_page.dart';
import 'package:login_page/sign_up.dart';

class LoginPage extends StatefulWidget {
  static const String path = "loginPage";
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ));
    final scaffold = ScaffoldMessenger.of(context);
    toast(text) {
      scaffold.showSnackBar(SnackBar(
          content: Text(
        text,
        style: TextStyle(color: Colors.red, fontFamily: "Raleway"),
      )));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Image.asset(
            "assets/images/f.png",
            height: MediaQuery.of(context).size.height * .30,
            width: MediaQuery.of(context).size.width * 1.0,
            fit: BoxFit.fill,
          ),
          Text(
            "Welcome Back!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontFamily: "Raleway",
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "log in to your existing account of facebook",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontFamily: "Raleway",
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: TextFormField(
                    controller: emailController,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Field must not be empty!";
                      } else if (!value.contains("@gmail.com")) {
                        return "please enter a valid email";
                      }
                      return null;
                    },
                    cursorColor: Colors.orange,
                    style: TextStyle(
                      color: Colors.blue,
                      letterSpacing: 1.3,
                      fontFamily: "Raleway",
                    ),
                    decoration: InputDecoration(
                      hintText: "Enter your email",
                      errorStyle: TextStyle(fontFamily: "Raleway"),
                      hintStyle: TextStyle(color: Colors.blue),
                      label: Text("Email"),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Icon(Icons.person_outline),
                      ),
                      suffixIcon: Icon(Icons.email_outlined),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 30,
                    right: 30,
                  ),
                  child: TextFormField(
                    controller: passController,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Field must not be empty!";
                      } else if (value.length < 8) {
                        return "Password should be at lest 8 characters";
                      }
                      return null;
                    },
                    obscureText: _obscureText,
                    cursorColor: Colors.orange,
                    style: TextStyle(
                      color: Colors.blue,
                      letterSpacing: 1.3,
                      fontFamily: "Raleway",
                    ),
                    decoration: InputDecoration(
                      hintText: "Enter your Password",
                      hintStyle: TextStyle(color: Colors.blue),
                      errorStyle: TextStyle(fontFamily: "Raleway"),
                      label: Text("Password"),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Icon(Icons.lock_outline),
                      ),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          icon: Icon(_obscureText
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined)),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Forgot password?",
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Raleway",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 80,
              right: 80,
              top: 12,
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                padding: EdgeInsets.all(15),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    UserCredential userCredential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passController.text);
                    Navigator.of(context).pushNamed(HomePage.path);
                  } catch (e) {
                    toast("please enter valid email or password!");
                  }
                }
              },
              child: Text(
                "LOG IN",
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: "Raleway",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          Text(
            "or connect with",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontFamily: "Raleway",
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.facebook),
                label: Text("Facebook"),
              ),
              SizedBox(width: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () {},
                icon: FaIcon(FontAwesomeIcons.google),
                label: Text("Google"),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Raleway",
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(SignUp.path);
                },
                child: Text(
                  "SignUp",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Raleway",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
