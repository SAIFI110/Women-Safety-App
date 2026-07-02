import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:women_safety/db/sp.dart';
import 'package:women_safety/childscreen/childlogin.dart';
import 'package:women_safety/childscreen/bottomscreens/childhomescreen.dart';
import 'package:women_safety/parentscreen/parenthomescreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

Timer(const Duration(seconds: 3), () {

  print("Firebase User: ${FirebaseAuth.instance.currentUser?.uid}");
  print("Login: ${MySharedPreference.getLogin()}");
  print("Role: ${MySharedPreference.getRole()}");

  bool isLoggedIn = MySharedPreference.getLogin();
  String? role = MySharedPreference.getRole();

  Widget nextScreen;

  if (isLoggedIn && role == "child") {
    nextScreen = Homescreen();
  } else if (isLoggedIn && role == "parent") {
    nextScreen = Parenthomescreen();
  } else {
    nextScreen = const LoginScreen();
  }

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => nextScreen,
    ),
  );

});

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Image.asset(
              "assets/logo women.png",
              width: 170,
            ),

            const SizedBox(height: 25),

            const Text(
              "Women Safety",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Stay Safe • Stay Strong",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 40),

            const CircularProgressIndicator(
              color: Colors.pink,
            ),
          ],
        ),
      ),
    );
  }
}