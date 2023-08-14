import 'package:flutter/material.dart';

import '../../src/colors.dart';

class EditProfileModal extends StatefulWidget {
  const EditProfileModal({
    super.key,
  });

  @override
  State<EditProfileModal> createState() => _EditProfileModalState();
}

class _EditProfileModalState extends State<EditProfileModal> {
  BoxDecoration modalLine() {
    return const BoxDecoration(
      border: Border(
          bottom: BorderSide(
        color: backgroundWhite,
        width: 1.0,
      )),
    );
  }

  String userFirstName = '';
  String userLastName = '';
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 750,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: modalLine(),
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Editing Profile',
                    style: TextStyle(
                        color: absentRed,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                  Icon(
                    Icons.circle,
                    size: 85,
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text('First name:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: SizedBox(
                      width: 200.0,
                      height: 50.0,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Enter first name...',
                          border:
                              OutlineInputBorder(), // Customize the border style
                        ),
                        onChanged: (value) {
                          // Handle the text input change
                          // ...
                        },
                        validator: (value) {
                          // Perform form validation and return an error message if necessary
                          // ...
                          return null; // Return null to indicate no validation errors
                        },
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
                  const Text('Last name:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: SizedBox(
                      width: 200.0,
                      height: 50.0,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText:
                              'Enter last name...', //should be user's name...
                          border:
                              OutlineInputBorder(), // Customize the border style
                        ),
                        onChanged: (value) {
                          // Handle the text input change
                          // ...
                        },
                        validator: (value) {
                          // Perform form validation and return an error message if necessary
                          // ...
                          return null; // Return null to indicate no validation errors
                        },
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
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'alldayadjei',
                          border:
                              OutlineInputBorder(), // Customize the border style
                        ),
                        onChanged: (value) {
                          // Handle the text input change
                          // ...
                        },
                        validator: (value) {
                          // Perform form validation and return an error message if necessary
                          // ...
                          return null; // Return null to indicate no validation errors
                        },
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
                  const Text('Password:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: SizedBox(
                      width: 200.0,
                      height: 50.0,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Password',
                          border:
                              OutlineInputBorder(), // Customize the border style
                        ),
                        onChanged: (value) {
                          // Handle the text input change
                          // ...
                        },
                        validator: (value) {
                          // Perform form validation and return an error message if necessary
                          // ...
                          return null; // Return null to indicate no validation errors
                        },
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
                      onPressed: () {},
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
