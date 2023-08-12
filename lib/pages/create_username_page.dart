import 'package:auth_test/components/my_textfield.dart';
import 'package:auth_test/pages/home_page.dart';
import 'package:auth_test/src/colors.dart';
import 'package:flutter/material.dart';

class CreateUsernamePage extends StatefulWidget {
  const CreateUsernamePage({super.key});

  @override
  State<CreateUsernamePage> createState() => _CreateUsernamePageState();
}

class _CreateUsernamePageState extends State<CreateUsernamePage> {
  bool hasUsername = false;
  TextEditingController usernameController = TextEditingController();

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
                    controller: usernameController,
                    hintText: '@YourUsername',
                    obscureText: false,
                    maxCharacters: 25,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
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
