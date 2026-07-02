import 'package:flutter/material.dart';
import 'package:women_safety/childscreen/bottomscreens/child_chat_users.dart';
import 'package:women_safety/widgets/home_widgets/customappbar.dart';
import 'package:women_safety/widgets/home_widgets/customcarousel.dart';
import 'package:women_safety/widgets/home_widgets/emergency.dart';
import 'package:women_safety/widgets/home_widgets/safehome/safehome.dart';
import 'package:women_safety/widgets/livesafe.dart';
import 'package:women_safety/childscreen/bottomscreens/contacts_page.dart';
import 'package:women_safety/childscreen/bottomscreens/profile_page.dart';
import 'package:women_safety/childscreen/bottomscreens/review_page.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int currentIndex = 0;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();

 pages = [
  const _HomeUI(),
  const ContactsPage(),
  const ChildChatUsers(),
  const ProfileScreen(),
  const ReviewPage(),
];
  }

  void onTabChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTabChanged,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: "Contacts",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rate_review),
            label: "Review",
          ),
      
        ],
      ),
    );
  }
}
class _HomeUI extends StatelessWidget {
  const _HomeUI();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomAppBar(),
              const SizedBox(height: 10),

              CustomCarousel(),

              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Emergency",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              Emergency(),

              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Explore LiveSafe",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              Livesafe(),
              Safehome(),
            ],
          ),
        ),
      ),
    );
  }
}