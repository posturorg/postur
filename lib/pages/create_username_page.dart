import 'package:auth_test/components/dialogs/default_one_option_dialog.dart';
import 'package:auth_test/components/my_textfield.dart';
import 'package:auth_test/pages/home_page.dart';
import 'package:auth_test/src/colors.dart';
import 'package:auth_test/src/user_info_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateUsernamePage extends StatefulWidget {
  const CreateUsernamePage({super.key});

  @override
  State<CreateUsernamePage> createState() => _CreateUsernamePageState();
}

class _CreateUsernamePageState extends State<CreateUsernamePage> {
  bool hasUsername = false; // on initState, get this from the backend.
  TextEditingController usernameController = TextEditingController();

  Future<void> fetchHasUsername() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.uid)
          .get();

      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      final hasNameFirebase = userData['hasUsername'];
      setState(() {
        hasUsername = hasNameFirebase;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchHasUsername();
  }

  @override
  Widget build(BuildContext context) {
    return hasUsername
        ? const HomePage()
        : Scaffold(
            appBar: AppBar(
              title: const Text(
                'Create Username',
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
                  const Text(
                    'Create your username:',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    child: Text(
                      "This won't be used for sign in, only to help people invite you to events.",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: MyTextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(
                            r'[a-zA-Z0-9]')), //allow only letters and numbers
                      ],
                      controller: usernameController,
                      hintText: 'YourUsername',
                      obscureText: false,
                      maxCharacters: 25,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      usernameController.text.trim();
                      String usernameTrimmed = usernameController.text;
                      if (usernameTrimmed != '') {
                        usernameController.text.toLowerCase();
                        bool? isUnique =
                            await isUsernameUnique(usernameController.text);
                        if (isUnique == null) {
                          //maybe make this nested loop cleaner...
                          //maybe clean up a bit
                          print('isUnique evaluated to null');
                          showDialog(
                            context: context,
                            builder: (context) {
                              return DefaultOneOptionDialog(
                                title:
                                    'Something went wrong. Please try again or restart your app.',
                                buttonText: 'Ok',
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              );
                            },
                          );
                        } else if (isUnique) {
                          setUsername(setState(() {
                            //Why did you crash...
                            hasUsername = true;
                          }));
                        } else {
                          showDialog(
                            context: (context),
                            builder: (context) {
                              return DefaultOneOptionDialog(
                                title: 'This username is already taken',
                                buttonText: 'Ok',
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              );
                            },
                          );
                        }
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => DefaultOneOptionDialog(
                            title: 'Please enter a valid username',
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
                  const SizedBox(height: 150),
                ],
              ),
            ),
          );
  }
}
