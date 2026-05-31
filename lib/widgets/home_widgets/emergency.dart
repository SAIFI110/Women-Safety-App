import 'package:flutter/material.dart';
import 'package:women_safety/widgets/home_widgets/emergencies/ambulanceemergency.dart';
import 'package:women_safety/widgets/home_widgets/emergencies/armyemergency.dart';
import 'package:women_safety/widgets/home_widgets/emergencies/firebrigadeemergency.dart';
import 'package:women_safety/widgets/home_widgets/emergencies/policeemergency.dart';

class Emergency extends StatelessWidget {
  const Emergency({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 180,
      child: ListView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          Policeemergency(),
          Armyemergency(),
          Ambulanceemergency(),
          Firebrigadeemergency(),
         
          
        ],
      ),
    );
  }
}