import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:women_safety/childscreen/bottomscreens/chat_screen.dart';
import 'package:women_safety/childscreen/childlogin.dart';
import 'package:women_safety/db/sp.dart';
import 'package:women_safety/utils/chat_helper.dart';

class Parenthomescreen extends StatelessWidget {
  const Parenthomescreen({super.key});

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    await MySharedPreference.clearData();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final String? uid = MySharedPreference.getUid();

    print("Firebase User: ${FirebaseAuth.instance.currentUser?.uid}");
    print("SharedPref UID: $uid");

    if (uid == null) {
      return const Scaffold(
        body: Center(
          child: Text("Please login again"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE91E63),
        title: const Text(
          "Guardian",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout, color: Colors.white),
          )
        ],
      ),

      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .get(),
        builder: (context, parentSnapshot) {
          if (parentSnapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!parentSnapshot.hasData ||
              !parentSnapshot.data!.exists) {
            return const Center(
              child: Text("Guardian not found"),
            );
          }

          final parentData =
              parentSnapshot.data!.data() as Map<String, dynamic>;

          final String childEmail =
              parentData["childEmail"]?.toString() ?? "";

          if (childEmail.isEmpty) {
            return const Center(
              child: Text("No child linked"),
            );
          }

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .where("role", isEqualTo: "child")
                .where("email", isEqualTo: childEmail)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (!snapshot.hasData ||
                  snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text("No Child Found"),
                );
              }

              final childDoc = snapshot.data!.docs.first;

              final child =
                  childDoc.data() as Map<String, dynamic>;

              final childUid = childDoc.id;

              final childName =
                  child["name"] ??
                  child["childName"] ??
                  "Child";

              final chatId =
                  ChatHelper.getChatId(uid, childUid);

              return ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  Card(
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      title: Text(childName),
                      subtitle: const Text("Child"),
                      trailing: const Icon(
                        Icons.chat,
                        color: Colors.pink,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatScreen(
                              chatId: chatId,
                              receiverId: childUid,
                              receiverName: childName,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}