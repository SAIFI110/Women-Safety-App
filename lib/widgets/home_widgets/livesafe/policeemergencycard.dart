import 'package:flutter/material.dart';
import 'package:women_safety/widgets/livesafe.dart';
 





class Policeemergencycard extends StatelessWidget {
  const Policeemergencycard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Livesafe.openMap("police stations near me");
              
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
                  child: Image.asset("assets/police-badge.png"),
                ),
              ),
            ),
          ),
          Text("Police Stations")
        ],
        
      ),
    );
  }
}