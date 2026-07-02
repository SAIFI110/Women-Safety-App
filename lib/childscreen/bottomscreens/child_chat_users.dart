import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:women_safety/utils/chat_helper.dart';
import 'package:women_safety/childscreen/bottomscreens/chat_screen.dart';

class ChildChatUsers extends StatelessWidget {
  const ChildChatUsers({super.key});

  @override
  Widget build(BuildContext context) {
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE91E63),
        centerTitle: true,
        title: const Text(
          "Guardian",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .get(),
        builder: (context, childSnapshot) {

          if (childSnapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!childSnapshot.hasData ||
              !childSnapshot.data!.exists) {
            return const Center(
              child: Text("Child not found"),
            );
          }

          final childData =
              childSnapshot.data!.data()
                  as Map<String, dynamic>;

          final String guardianEmail =
              childData["guardianEmail"];

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .where("role", isEqualTo: "parent")
                .where("email", isEqualTo: guardianEmail)
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
                  child: Text("No Guardian Found"),
                );
              }

              final parentDoc = snapshot.data!.docs.first;

              final parent =
                  parentDoc.data() as Map<String, dynamic>;

              final String parentUid = parentDoc.id;

              final String chatId =
                  ChatHelper.getChatId(uid, parentUid);

              return Padding(
                padding: const EdgeInsets.all(12),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    title: Text(
                      parent["name"],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    subtitle: const Text("Guardian"),
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
                            receiverId: parentUid,
                            receiverName: parent["name"],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}