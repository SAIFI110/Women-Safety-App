import 'package:flutter/material.dart';
import 'package:women_safety/widgets/livesafe.dart';

class Hospital extends StatelessWidget {
  const Hospital({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Livesafe.openMap("hospitals near me");
              
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
                  child: Image.asset("assets/hospital.png"),
                ),
              ),
            ),
          ),
          Text("Hospital")
        ],
      ),
    );
  
  }
}