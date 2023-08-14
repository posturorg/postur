import 'package:auth_test/components/dialogs/default_one_option_dialog.dart';
import 'package:auth_test/components/dialogs/default_two_option_dialog.dart';
import 'package:auth_test/components/my_textfield.dart';
import 'package:auth_test/src/user_info_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../src/colors.dart';

class EditProfileModal extends StatefulWidget {
  const EditProfileModal({
    super.key,
  });

  @override
  State<EditProfileModal> createState() => _EditProfileModalState();
}

class _EditProfileModalState extends State<EditProfileModal> {
  String userFirstName = '';
  String userLastName = '';
  String userUsername = ''; //user's current Username

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  Future<void> initializeData() async {
    await fetchUsersInfo();
    firstNameController.text = userFirstName;
    lastNameController.text = userLastName;
    usernameController.text = userUsername;
  }

  Future<void> fetchUsersInfo() async {
    final User currentUser = FirebaseAuth.instance.currentUser!;

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final DocumentSnapshot userSnapshot =
        await _firestore.collection('Users').doc(currentUser.uid).get();
    final userData = userSnapshot.data() as Map<String, dynamic>;
    final usersName = userData['name'] as Map<String, dynamic>;
    final theUsersUsername = userData['username'] as String;

    setState(() {
      userFirstName = usersName['first']!;
      userLastName = usersName['last']!;
      userUsername = theUsersUsername;
    });
    print(userFirstName); // Now this should print the correct value
  }

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 750,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              //padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Editing Profile',
                    style: TextStyle(
                        color: absentRed,
                        fontWeight: FontWeight.bold,
                        fontSize: 21),
                  ),
                  Icon(
                    Icons.circle,
                    size: 85,
                  ),
                ],
              ),
            ),
            const Divider(color: backgroundWhite),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 7, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'First name:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: SizedBox(
                      width: 200.0,
                      height: 50.0,
                      child: MyTextField(
                        controller: firstNameController,
                        hintText: 'Enter first name...',
                        obscureText: false,
                        maxCharacters: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Last name:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: SizedBox(
                      width: 200.0,
                      height: 50.0,
                      child: MyTextField(
                        controller: lastNameController,
                        hintText: 'Enter last name...',
                        obscureText: false,
                        maxCharacters: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Username:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: SizedBox(
                      width: 200.0,
                      height: 50.0,
                      child: MyTextField(
                        maxCharacters: 25,
                        controller: usernameController,
                        hintText: 'Enter desired username...',
                        obscureText: false,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z0-9]')),
                        ], //WE MUST TRIM USERNAME AND MAKE IT LOWERCASE BEFORE SUBMITTING TO BACKEND!!!
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 20),
                        backgroundColor: neutralGrey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13)),
                        elevation: 0.0,
                      ),
                      child: const Text('Cancel',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          )),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        //Shows loading popup...
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(absentRed),
                              ),
                            );
                          },
                        );
                        try {
                          //conditions for updating userName...
                          String queriedName =
                              usernameController.text.trim().toLowerCase();
                          bool isUniqueUsername =
                              await isUsernameUnique(queriedName);
                          if (isUniqueUsername || queriedName == userUsername) {
                            if (usernameController.text.trim() == '' ||
                                firstNameController.text.trim() == '') {
                              Navigator.pop(context); //pops wheeel
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return DefaultOneOptionDialog(
                                    title:
                                        'Username & First name cannot be empty.',
                                    buttonText: 'Ok',
                                    onPressed: () {
                                      Navigator.pop(context); //pops popup.
                                    },
                                  );
                                },
                              );
                            } else {
                              //Confirm changes
                              Navigator.pop(context); //pops wheel
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return DefaultTwoOptionDialog(
                                    title: 'Confirm these changes?',
                                    optionOneText: 'Yes',
                                    optionTwoText: 'No',
                                    onOptionOne: () {
                                      setUsername(null, usernameController);
                                      setName(
                                        null,
                                        firstNameController,
                                        lastNameController,
                                      );
                                      Navigator.pop(context); //pops popup
                                      Navigator.pop(context); //pops modal
                                    },
                                    onOptionTwo: () {
                                      Navigator.pop(context); //pops popup
                                    },
                                  );
                                },
                              );
                            }
                          } else {
                            Navigator.pop(context); //pops wheel
                            showDialog(
                              context: context,
                              builder: (context) {
                                return DefaultOneOptionDialog(
                                  title: 'Username is already taken',
                                  buttonText: 'Ok',
                                  onPressed: () {
                                    Navigator.pop(context); //closes popup...
                                  },
                                );
                              },
                            );
                          }
                        } catch (e) {
                          Navigator.pop(context); // pops spinning wheel
                          showDialog(
                            context: context,
                            builder: (context) {
                              return DefaultOneOptionDialog(
                                title: e.toString(),
                                buttonText: 'Ok',
                                onPressed: () {
                                  Navigator.pop(context); // pops error popup
                                },
                              );
                            },
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 14),
                        backgroundColor: absentRed,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13)),
                        elevation: 0.0,
                      ),
                      child: const Text('Confirm',
                          style: TextStyle(color: Colors.white, fontSize: 15)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
