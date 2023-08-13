import 'dart:async';

import 'package:auth_test/components/dialogs/default_one_option_dialog.dart';
import 'package:auth_test/components/my_textfield.dart';
import 'package:auth_test/pages/create_username_page.dart';
import 'package:auth_test/src/colors.dart';
import 'package:auth_test/src/user_info_services.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NamesEntryPage extends StatefulWidget {
  const NamesEntryPage({super.key});

  @override
  State<NamesEntryPage> createState() => _NamesEntryPageState();
}

class _NamesEntryPageState extends State<NamesEntryPage> {
  bool hasName = false; // should pull this from the backend on initState.
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  Future<void> fetchHasName() async {
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

        final hasNameFirebase = userData['hasName'];
        setState(() {
          hasName = hasNameFirebase;
        });
      }
      Navigator.pop(context); //pops loading circle
    } catch (e) {
      Navigator.pop(context); //pops loading circle
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
    //get value of hasName from the backend...
    Future.delayed(Duration.zero, () {
      this.fetchHasName();
    });
  }

  @override
  Widget build(BuildContext context) {
    return hasName
        ? const CreateUsernamePage()
        : Scaffold(
            appBar: AppBar(
              title: const Text(
                'Additional Info',
                style: TextStyle(
                  color: absentRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyTextField(
                    controller: firstNameController,
                    hintText: 'First name',
                    obscureText: false,
                    maxCharacters: 30,
                  ),
                  const SizedBox(height: 15),
                  MyTextField(
                    controller: lastNameController,
                    hintText: 'Last name (recommended)',
                    obscureText: false,
                    maxCharacters: 30,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                    child: Text(
                      'Your last name will only ever be shown to people in your contacts or friends.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (firstNameController.text.trim() != '') {
                        setName(
                          () {
                            setState(() {
                              //Why did you crash...
                              print('set Name occurs');
                              hasName = true;
                            });
                          },
                          firstNameController,
                          lastNameController,
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => DefaultOneOptionDialog(
                            title: 'Please enter a valid first name',
                            buttonText: 'Ok',
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.arrow_upward_rounded),
                    label: const Text('Confirm'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: absentRed,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          );
  }
}
