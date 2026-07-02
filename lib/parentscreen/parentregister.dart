import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Registerparent extends StatefulWidget {
  const Registerparent({super.key});

  @override
  State<Registerparent> createState() => _RegisterparentState();
}

class _RegisterparentState extends State<Registerparent> {
  final _formKey = GlobalKey<FormState>();

  String name = "";
  String email = "";
  String childEmail = "";
  String childName = "";
  String password = "";
  String confirmPassword = "";

  bool loading = false;

  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');

  void register() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords do not match"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => loading = true);

    try {
      // Create Auth user
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      String uid = userCredential.user!.uid;

      // Save to Firestore
      await FirebaseFirestore.instance.collection("users").doc(uid).set({
        "name": name.trim(),
        "email": email.trim(),
        "childName": childName.trim(),
        "childEmail": childEmail.trim(),
        "role": "parent",
        "createdAt": Timestamp.now(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Parent Registered Successfully"),
          backgroundColor: Colors.green,
        ),
      );

      await FirebaseAuth.instance.signOut();

      if (!mounted) return;

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Registration Failed"),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
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
                  const SizedBox(height: 50),

                  Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.pink.shade200,
                          Colors.pink.shade400,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.person_add,
                      color: Colors.white,
                      size: 55,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Parent Account",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Parent Name
                  TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person),
                      hintText: "Parent Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Name is required" : null,
                    onSaved: (value) => name = value!.trim(),
                  ),

                  const SizedBox(height: 12),

                  // Parent Email
                  TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email),
                      hintText: "Parent Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) =>
                        emailRegex.hasMatch(value!.trim())
                            ? null
                            : "Enter valid email",
                    onSaved: (value) => email = value!.trim(),
                  ),

                  const SizedBox(height: 12),

                  // Child Name
                  TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.family_restroom),
                      hintText: "Child Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Child name is required" : null,
                    onSaved: (value) => childName = value!.trim(),
                  ),

                  const SizedBox(height: 12),

                  // Child Email
                  TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email_outlined),
                      hintText: "Child Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) =>
                        emailRegex.hasMatch(value!.trim())
                            ? null
                            : "Enter valid child email",
                    onSaved: (value) => childEmail = value!.trim(),
                  ),

                  const SizedBox(height: 12),

                  // Password
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      hintText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) =>
                        value!.length < 6
                            ? "Min 6 characters required"
                            : null,
                    onSaved: (value) => password = value!.trim(),
                  ),

                  const SizedBox(height: 12),

                  // Confirm Password
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline),
                      hintText: "Confirm Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Confirm password required" : null,
                    onSaved: (value) => confirmPassword = value!.trim(),
                  ),

                  const SizedBox(height: 25),

                  // Register Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: loading ? null : register,
                      child: loading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Register",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Login link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.pink,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}