import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:women_safety/services/chat_service.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String receiverId;
  final String receiverName;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.receiverId,
    required this.receiverName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService _chatService = ChatService();

  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ImagePicker picker = ImagePicker();

  String get myUid => FirebaseAuth.instance.currentUser!.uid;

  // ================= SEND TEXT =================
  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty) return;

    await _chatService.sendMessage(
      chatId: widget.chatId,
      receiverId: widget.receiverId,
      text: messageController.text.trim(),
      type: "text",
    );

    messageController.clear();
  }

  // ================= DELETE MESSAGE =================
  Future<void> deleteMessage(String messageId) async {
    await FirebaseFirestore.instance
        .collection("chats")
        .doc(widget.chatId)
        .collection("messages")
        .doc(messageId)
        .delete();
  }

  // ================= EDIT MESSAGE =================
  Future<void> editMessage(String messageId, String oldText) async {
    TextEditingController editController =
        TextEditingController(text: oldText);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Message"),
        content: TextField(controller: editController),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection("chats")
                  .doc(widget.chatId)
                  .collection("messages")
                  .doc(messageId)
                  .update({
                "text": editController.text.trim(),
              });

              Navigator.pop(context);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  // ================= SEND LOCATION =================
  Future<void> sendLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    String mapLink =
        "https://www.google.com/maps?q=${position.latitude},${position.longitude}";

    await _chatService.sendMessage(
      chatId: widget.chatId,
      receiverId: widget.receiverId,
      text: mapLink,
      type: "location",
    );
  }

  // ================= SEND IMAGE =================
  Future<void> sendImage(ImageSource source) async {
    final XFile? file = await picker.pickImage(source: source);

    if (file == null) return;

    File imageFile = File(file.path);

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    final ref = FirebaseStorage.instance
        .ref()
        .child("chatImages/$fileName");

    await ref.putFile(imageFile);

    String url = await ref.getDownloadURL();

    await _chatService.sendMessage(
      chatId: widget.chatId,
      receiverId: widget.receiverId,
      text: url,
      type: "image",
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE91E63),
        title: Text(widget.receiverName),
        centerTitle: true,
      ),

      body: Column(
        children: [
          // ================= MESSAGES =================
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _chatService.getMessages(widget.chatId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  controller: scrollController,
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    
                    // ✅ SAFE TYPE FIX
                    final data =
                        (docs[index].data() as Map<String, dynamic>?) ?? {};

                    final messageId = docs[index].id.toString();
                    final isMe = data["senderId"] == myUid;
                    final type = (data["type"] ?? "text").toString();
                    final text = (data["text"] ?? "").toString();

                    return GestureDetector(
                      onLongPress: isMe && type == "text"
                          ? () => editMessage(messageId, text)
                          : null,
                      child: Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.all(6),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color:
                                isMe ? Colors.pink : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              // ================= TEXT =================
                              if (type == "text")
                                Text(
                                  text,
                                  style: TextStyle(
                                    color:
                                        isMe ? Colors.white : Colors.black,
                                  ),
                                ),

                              // ================= IMAGE =================
                              if (type == "image")
                                Image.network(
                                  text,
                                  width: 200,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          const Icon(Icons.broken_image),
                                ),

                              // ================= LOCATION =================
                              if (type == "location")
                                InkWell(
                                  onTap: () async {
                                    if (text.isNotEmpty) {
                                      await launchUrl(Uri.parse(text));
                                    }
                                  },
                                  child: const Text(
                                    "📍 Open Location",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),

                              // ================= DELETE =================
                              if (isMe)
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                  onPressed: () =>
                                      deleteMessage(messageId),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // ================= INPUT BAR =================
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: () => sendImage(ImageSource.gallery),
                ),

                IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: () => sendImage(ImageSource.camera),
                ),

                IconButton(
                  icon: const Icon(Icons.location_on),
                  onPressed: sendLocation,
                ),

                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: "Type message...",
                    ),
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.send, color: Colors.pink),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}