import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:women_safety/childscreen/childlogin.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  bool loading = false;

  Future<void> editName(String currentName) async {
    TextEditingController controller =
        TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Name"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Enter new name",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isEmpty) return;

              await FirebaseFirestore.instance
                  .collection("users")
                  .doc(uid)
                  .update({
                "name": controller.text.trim(),
              });

              if (mounted) Navigator.pop(context);

              setState(() {});
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: Colors.pink,
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
      ),
body: FutureBuilder<DocumentSnapshot>(
  future: FirebaseFirestore.instance
      .collection("users")
      .doc(uid)
      .get(),
  builder: (context, snapshot) {

    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (snapshot.hasError) {
      return Center(
        child: Text("Error: ${snapshot.error}"),
      );
    }

    if (!snapshot.hasData || !snapshot.data!.exists) {
      return const Center(
        child: Text("User document not found"),
      );
    }

    final data = snapshot.data!.data() as Map<String, dynamic>;

    final String name = data["name"] ?? "";
    final String email = data["email"] ?? "";
    final String role = data["role"] ?? "";

    // Yahan se tumhara baaki UI waise hi rahega

          return SingleChildScrollView(
            child: Column(
              children: [

                const SizedBox(height: 30),

                CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.pink,
                  child: Text(
                    name.isEmpty
                        ? "U"
                        : name[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  email,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                  ),
                ),

                const SizedBox(height: 5),

                Chip(
                  backgroundColor: Colors.pink.shade100,
                  label: Text(
                    role.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [

                      ListTile(
                        leading: const Icon(
                          Icons.edit,
                          color: Colors.pink,
                        ),
                        title: const Text("Edit Name"),
                        trailing:
                            const Icon(Icons.arrow_forward_ios),
                        onTap: () => editName(name),
                      ),

                      const Divider(height: 1),

                      ListTile(
                        leading: const Icon(
                          Icons.email,
                          color: Colors.blue,
                        ),
                        title: const Text("Email"),
                        subtitle: Text(email),
                      ),

                      const Divider(height: 1),

                      ListTile(
                        leading: const Icon(
                          Icons.person,
                          color: Colors.green,
                        ),
                        title: const Text("Role"),
                        subtitle: Text(role),
                      ),

                      const Divider(height: 1),

                      ListTile(
                        leading: const Icon(
                          Icons.info,
                          color: Colors.orange,
                        ),
                        title: const Text("About App"),
                        subtitle: const Text(
                          "Women Safety App v1.0",
                        ),
                      ),

                      const Divider(height: 1),

                      ListTile(
                        leading: const Icon(
                          Icons.logout,
                          color: Colors.red,
                        ),
                        title: const Text("Logout"),
                        onTap: logout,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}