import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ParentChatUsers extends StatelessWidget {
  const ParentChatUsers({super.key});

  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text("My Child")),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .get(),
        builder: (context, parentSnap) {
          if (parentSnap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!parentSnap.hasData || !parentSnap.data!.exists) {
            return const Center(child: Text("Parent document not found"));
          }

          Map<String, dynamic> parentData =
              parentSnap.data!.data() as Map<String, dynamic>;

          debugPrint("Parent Data => $parentData");

          String childName = parentData["childName"] ?? "";

          debugPrint("Child Name => $childName");

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .where("role", isEqualTo: "child")
                .where("name", isEqualTo: childName)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              debugPrint(
                  "Children Found => ${snapshot.data?.docs.length}");

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text("No Child Found"),
                );
              }

              Map<String, dynamic> child =
                  snapshot.data!.docs.first.data()
                      as Map<String, dynamic>;

              return ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text(child["name"] ?? ""),
                subtitle: Text(child["email"] ?? ""),
                trailing: const Icon(Icons.chat),
              );
            },
          );
        },
      ),
    );
  }
}