import 'package:flutter/material.dart';
import 'package:women_safety/widgets/livesafe.dart';

class Busstation extends StatelessWidget {
  const Busstation({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Livesafe.openMap("bus stops near me");
              
            },
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                  
              ),
              child: Container(
                height: 50,
                width: 50,
                child: Center(
                  child: Image.asset("assets/bus-stop.png"),
                ),
              ),
            ),
          ),
          Text("bus stop")
        ],
      ),
    );
  }
}