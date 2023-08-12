import 'package:auth_test/components/dialogs/default_one_option_dialog.dart';
import 'package:auth_test/components/my_textfield.dart';
import 'package:auth_test/pages/home_page.dart';
import 'package:auth_test/src/colors.dart';
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

  Future setUsername() async {
    //set this on backend
    setState(() {
      //this shouldn't be done on the frontend AT ALL.
      //Should be listening perpetually to the backend.
      usernameController.text.toLowerCase();
      hasUsername = true;
    });
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
            body: Column(
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
                    hintText: '@YourUsername',
                    obscureText: false,
                    maxCharacters: 25,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (usernameController.text.trim() != '') {
                      //ALSO NEED TO MAKE SURE NO OTHER USER HAS SAME USERNAME!
                      //ALSO NEED TO ADD CONDITION TO CHECK FOR OTHER SPECIAL CHARACTERS AND FORBID THEM!
                      setUsername();
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => DefaultOneOptionDialog(
                          title: 'title',
                          buttonText: 'Poop',
                          onPressed: () {},
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
          );
  }
}