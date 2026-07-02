import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:women_safety/db/contact_db.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';


class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  // DEVICE CONTACTS
  List<Contact> deviceContacts = [];
  List<Contact> filteredDeviceContacts = [];

  // APP CONTACTS (SQFLITE)
  List<Map<String, dynamic>> appContacts = [];

  bool loading = true;

  final searchController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    await getDeviceContacts();
    await loadAppContacts();
  }

  // 📱 DEVICE CONTACTS
  Future<void> getDeviceContacts() async {
    PermissionStatus permission = await Permission.contacts.request();

    if (permission.isGranted) {
      deviceContacts =
          await FlutterContacts.getContacts(withProperties: true);

      filteredDeviceContacts = deviceContacts;
    }

    setState(() => loading = false);
  }

  // 💾 APP CONTACTS
  Future<void> loadAppContacts() async {
    appContacts = await ContactsDB.getAll();
    setState(() {});
  }

  // 🔍 SEARCH
  void search(String value) {
    setState(() {
      filteredDeviceContacts = deviceContacts
          .where((c) =>
              c.displayName.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  // 📞 CALL FUNCTION
  void makeCall(String number) async {
  await FlutterPhoneDirectCaller.callNumber(number);
}

  // ➕ ADD CONTACT
  void addContact() async {
    await ContactsDB.insert(
      nameController.text,
      phoneController.text,
    );

    nameController.clear();
    phoneController.clear();

    await loadAppContacts();
    Navigator.pop(context);
  }

  // ❌ DELETE CONTACT
  void deleteContact(int id) async {
    await ContactsDB.delete(id);
    await loadAppContacts();
  }

  // ➕ DIALOG
  void showAddDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Contact"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: "Phone"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: addContact,
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text("Contacts VIP System"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: showAddDialog,
          )
        ],
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())

          : Column(
              children: [
                // 🔍 SEARCH
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: searchController,
                    onChanged: search,
                    decoration: InputDecoration(
                      hintText: "Search device contacts...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                // 📱 DEVICE CONTACTS
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Device Contacts",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: filteredDeviceContacts.length,
                    itemBuilder: (context, index) {
                      final contact = filteredDeviceContacts[index];

                      final phone = contact.phones.isNotEmpty
                          ? contact.phones.first.number
                          : "";

                      return ListTile(
                        title: Text(contact.displayName),
                        subtitle: Text(phone),
                        trailing: IconButton(
                          icon: const Icon(Icons.call, color: Colors.green),
                          onPressed: phone.isEmpty
                              ? null
                              : () => makeCall(phone),
                        ),
                      );
                    },
                  ),
                ),

                const Divider(),

                // 💾 APP CONTACTS
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Trusted Contacts",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: appContacts.length,
                    itemBuilder: (context, index) {
                      final c = appContacts[index];

                      return ListTile(
                        title: Text(c['name']),
                        subtitle: Text(c['phone']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.call,
                                  color: Colors.green),
                              onPressed: () => makeCall(c['phone']),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.red),
                              onPressed: () => deleteContact(c['id']),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}