import 'package:flutter/material.dart';
import 'package:women_safety/widgets/home_widgets/customappbar.dart';
import 'package:women_safety/widgets/home_widgets/customcarousel.dart';
import 'package:women_safety/widgets/home_widgets/emergency.dart';
import 'package:women_safety/widgets/home_widgets/safehome/safehome.dart';
import 'package:women_safety/widgets/livesafe.dart';





class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               
                const CustomAppBar(),
                 
                const SizedBox(height: 10),
        
                // 👉 Top aligned carousel
                CustomCarousel(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Emergency",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                ),
                Emergency(),
                
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Explore LiveSafe",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                ),
                Livesafe(),
                Safehome(),
                
                
               
               
              
              
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}