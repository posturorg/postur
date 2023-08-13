import 'package:auth_test/components/dialogs/default_one_option_dialog.dart';
import 'package:auth_test/pages/home_page.dart';
import 'package:auth_test/src/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ContactsPermissionsPage extends StatefulWidget {
  const ContactsPermissionsPage({super.key});

  @override
  State<ContactsPermissionsPage> createState() =>
      _ContactsPermissionsPageState();
}

class _ContactsPermissionsPageState extends State<ContactsPermissionsPage> {
  bool hasAllowedContacts = false;

  Future<void> fetchHasAllowedContacts() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(absentRed),
          ),
        );
      },
    );
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser.uid)
            .get();

        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        final hasAllowedContactsFirebase = userData['hasAllowedContacts'];
        setState(() {
          hasAllowedContacts = hasAllowedContactsFirebase;
        });
      }
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) {
          return DefaultOneOptionDialog(
            title: e.toString(),
            buttonText: 'Ok',
            onPressed: () {
              Navigator.pop(context);
            },
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    //fetchHasAllowedContacts();
  }

  @override
  Widget build(BuildContext context) {
    return hasAllowedContacts
        ? const HomePage()
        : Scaffold(
            appBar: AppBar(
              title: const Text(
                'Contact Permissions',
                style: TextStyle(
                  color: absentRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Please grant access to your contacts.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'This is only used to to friend people you already know.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 350),
                  ElevatedButton.icon(
                    onPressed: () {
                      print('done pressed!');
                    },
                    icon: const Icon(Icons.check_box_rounded),
                    label: const Text('Done'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: absentRed,
                    ),
                  ),
                  const SizedBox(height: 110),
                ],
              ),
            ),
          );
  }
}
