import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:women_safety/childscreen/bottomscreens/childhomescreen.dart';
import 'package:women_safety/childscreen/register_child.dart';
import 'package:women_safety/db/sp.dart';
import 'package:women_safety/parentscreen/parenthomescreen.dart';
import 'package:women_safety/parentscreen/parentregister.dart';
import 'package:women_safety/utils/constants.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  bool loading = false;

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    setState(() => loading = true);

    try {
      // 🔐 Firebase Login
     UserCredential userCredential =
    await FirebaseAuth.instance.signInWithEmailAndPassword(
  email: email.trim(),
  password: password.trim(),
);

print("userCredential.user = ${userCredential.user}");
print("userCredential.user.uid = ${userCredential.user?.uid}");

if (userCredential.user == null) {
  print("LOGIN FAILED - USER IS NULL");
  return;
}

String uid = userCredential.user!.uid;


      

      // 📦 Firestore Role Fetch
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();

      if (!userDoc.exists) {
        throw Exception("User not found");
      }

      String role =
          (userDoc.data() as Map<String, dynamic>)["role"]
              .toString()
              .toLowerCase();

      // 💾 SAVE IN SHARED PREFERENCES
      await MySharedPreference.setRole(role);
      await MySharedPreference.setUid(uid);
      await MySharedPreference.setLogin(true);

      print("ROLE SAVED: ${MySharedPreference.getRole()}");
      print("UID SAVED: ${MySharedPreference.getUid()}");

      setState(() => loading = false);

      // ✅ SUCCESS MESSAGE
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login Successful"),
          backgroundColor: Colors.green,
        ),
      );

      await Future.delayed(const Duration(milliseconds: 300));

      // 🚀 ROLE BASED NAVIGATION
      Widget nextScreen;

      if (role == "child") {
        nextScreen = Homescreen();
      } else if (role == "parent") {
        nextScreen = Parenthomescreen();
      } else {
        throw Exception("Invalid role");
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => nextScreen),
      );
    } catch (e) {
      setState(() => loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 60),

                  const Icon(
                    Icons.woman,
                    size: 80,
                    color: Colors.pink,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Women Safety Login",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  TextFormField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      hintText: "Email",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Email is required" : null,
                    onSaved: (value) => email = value!,
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      hintText: "Password",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Password is required" : null,
                    onSaved: (value) => password = value!,
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: loading ? null : login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                      ),
                      child: loading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Login",
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: () => goTo(context, RegisterChild()),
                    child: const Text("Register as Child"),
                  ),

                  const SizedBox(height: 10),

                  GestureDetector(
                    onTap: () => goTo(context, Registerparent()),
                    child: const Text("Register as Parent"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}