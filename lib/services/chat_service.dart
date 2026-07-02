import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Send Message
Future<void> sendMessage({
  required String chatId,
  required String receiverId,
  required String text,
  String type = "text",   // ✅ ADD THIS
}) async {
  String senderId = FirebaseAuth.instance.currentUser!.uid;

  if (text.trim().isEmpty) return;

  // Save Message
  await _firestore
      .collection("chats")
      .doc(chatId)
      .collection("messages")
      .add({
    "senderId": senderId,
    "receiverId": receiverId,
    "text": text.trim(),
    "type": type, // ✅ ADD THIS
    "timestamp": FieldValue.serverTimestamp(),
  });

  // Update Chat Document
  await _firestore.collection("chats").doc(chatId).set({
    "participants": [senderId, receiverId],
    "lastMessage": text.trim(),
    "lastMessageTime": FieldValue.serverTimestamp(),
  }, SetOptions(merge: true));
}

  /// Get Messages
  Stream<QuerySnapshot> getMessages(String chatId) {
    return _firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  /// Get Chat List
  Stream<QuerySnapshot> getChats() {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    return _firestore
        .collection("chats")
        .where("participants", arrayContains: uid)
        .orderBy("lastMessageTime", descending: true)
        .snapshots();
  }

  /// Delete Message (Optional)
  Future<void> deleteMessage({
    required String chatId,
    required String messageId,
  }) async {
    await _firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .doc(messageId)
        .delete();
  }
}