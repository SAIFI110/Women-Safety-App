import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:women_safety/widgets/home_widgets/livesafe/busstation.dart';
import 'package:women_safety/widgets/home_widgets/livesafe/hospital.dart';
import 'package:women_safety/widgets/home_widgets/livesafe/pharmacy.dart';
import 'package:women_safety/widgets/home_widgets/livesafe/policeemergencycard.dart';

class Livesafe extends StatelessWidget {
  const Livesafe({super.key});
static Future<void> openMap(String query) async {
  final Uri url = Uri.parse(
    "https://www.google.com/maps/search/$query",
    

  );

  try {
    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  } catch (e) {
    debugPrint("Map open error: $e");
  }
}
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          Policeemergencycard(),
          Pharmacy(),
          Hospital(),
          Busstation(),
          
        ],
      ),
    );
  }
}