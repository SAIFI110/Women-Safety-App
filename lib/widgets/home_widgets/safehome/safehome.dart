import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shake/shake.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:women_safety/db/contact_db.dart';

class Safehome extends StatefulWidget {
  const Safehome({super.key});

  @override
  State<Safehome> createState() => _SafehomeState();
}

class _SafehomeState extends State<Safehome> {
  late ShakeDetector detector;
  bool isSendingSOS = false;

  @override
  void initState() {
    super.initState();

    detector = ShakeDetector.autoStart(
      shakeThresholdGravity: 2.7,
      onPhoneShake: (ShakeEvent event) {
  sendSOS(context);
}
    );
  }

  void _onPhoneShake() {
    if (isSendingSOS) return;

    isSendingSOS = true;

    debugPrint("📳 Phone Shaken");

    sendSOS(context);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("🚨 SOS Triggered by Shake"),
        ),
      );
    }

    Future.delayed(const Duration(seconds: 5), () {
      isSendingSOS = false;
    });
  }

  @override
  void dispose() {
    detector.stopListening();
    super.dispose();
  }

  // ==========================
  // GET CURRENT LOCATION
  // ==========================

  Future<Position?> getLocation() async {
    bool serviceEnabled =
        await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return null;
    }

    LocationPermission permission =
        await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission =
          await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // ==========================
  // GET TRUSTED CONTACTS
  // ==========================

  Future<List<String>> getTrustedNumbers() async {
    final contacts = await ContactsDB.getAll();

    return contacts
        .map((e) => e["phone"].toString())
        .toList();
  }

  // ==========================
  // SEND SMS
  // ==========================

  Future<void> sendSMS(
      String number,
      String message,
      ) async {
    final Uri uri = Uri(
      scheme: "sms",
      path: number,
      queryParameters: {
        "body": message,
      },
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }


  // 🚨 SOS FUNCTION
   // ==========================
  // SEND SOS
  // ==========================

  Future<void> sendSOS(BuildContext context) async {
    try {
      Position? position = await getLocation();

      if (position == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Location not available"),
            ),
          );
        }
        return;
      }

      List<String> numbers = await getTrustedNumbers();

      if (numbers.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("No trusted contacts found"),
            ),
          );
        }
        return;
      }

      String message = '''
🚨 EMERGENCY ALERT 🚨

I am in danger. Please help me immediately.

My Live Location:
https://maps.google.com/?q=${position.latitude},${position.longitude}

Please contact me ASAP.
''';

      for (String number in numbers) {
        await sendSMS(number, message);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("SOS Sent Successfully"),
          ),
        );
      }
    } catch (e) {
      debugPrint("SOS ERROR: $e");
    }
  }

  // ==========================
  // EMERGENCY PANEL
  // ==========================

  void showmodelSafehome(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 280,
          child: Column(
            children: [
              const SizedBox(height: 10),

              const Text(
                "Emergency Actions",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  icon: const Icon(
                    Icons.warning,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Send SOS",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    sendSOS(context);
                  },
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  icon: const Icon(
                    Icons.location_on,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Test Location",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    Position? pos = await getLocation();

                    if (pos != null && mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Lat: ${pos.latitude}\nLng: ${pos.longitude}",
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () => showmodelSafehome(context),
              child: Container(
                height: 110,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      Colors.red.shade400,
                      Colors.red.shade700,
                    ],
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Emergency SOS Panel",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}