import 'dart:math';
import 'package:flutter/material.dart';
import 'package:women_safety/utils/quotes.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  String currentText = SweetSayings[0];

  void changeText() {
    setState(() {
      currentText = SweetSayings[Random().nextInt(SweetSayings.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: GestureDetector(
        onTap: changeText,
        child: Text(
          currentText,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}