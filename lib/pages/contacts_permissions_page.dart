import 'package:auth_test/components/dialogs/default_one_option_dialog.dart';
import 'package:auth_test/pages/home_page.dart';
import 'package:auth_test/src/colors.dart';
import 'package:auth_test/src/user_info_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// AndroidManifest.xml and Info.plist also modified in installation.
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactsPermissionsPage extends StatefulWidget {
  const ContactsPermissionsPage({super.key});

  @override
  State<ContactsPermissionsPage> createState() =>
      _ContactsPermissionsPageState();
}

class _ContactsPermissionsPageState extends State<ContactsPermissionsPage> {
  bool hasAllowedContacts = false;
  Set<String> othersPhoneNumbers = {};

  Future getContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      //REJECTED
      //send othersPhoneNumbers to backend...
      setState(() => hasAllowedContacts = true); //proceed to app
      //don't change backend value of hasAllowedContacts.
    } else {
      //ACCEPTED
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
        final List<Contact> contacts = await FlutterContacts.getContacts();
        othersPhoneNumbers = await extractPhoneNumbers(
            contacts); //make sure this does not include your own.

        setState(() {
          //change othersPhoneNumbers to a new value
        });
        //send othersPhoneNumbers to backend...
        //change backend value of hasAllowedContacts to true.
        final currentUser = FirebaseAuth.instance.currentUser;
        setState(() {
          hasAllowedContacts = true;
        });
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
  }

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

        final bool hasAllowedContactsFirebase = userData['hasAllowedContacts'];
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
    Future.delayed(Duration.zero, () {
      this.fetchHasAllowedContacts();
    });
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
                    'This is only used to friend people you already know.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 60),
                  ElevatedButton.icon(
                    onPressed: () {
                      // here is where we will upload contacts
                    },
                    icon: const Icon(Icons.check_rounded),
                    label: const Text('Accept'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: absentRed,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        hasAllowedContacts = true;
                      });
                    },
                    child: Text('NEXT PAGE!'),
                  ),
                  const SizedBox(height: 110),
                ],
              ),
            ),
          );
  }
}
