import 'package:auth_test/components/dialogs/default_one_option_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../src/colors.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({
    super.key,
    required this.onTap,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controller
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  // sign user in function
  void signUserIn() async {
    // show loading circle
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

    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // pop the loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);
      // WRONG EMAIL
      if (e.code == 'user-not-found') {
        showErrorMessage('No User with that Email');
        // WRONG PASSWORD
      } else if (e.code == 'wrong-password') {
        showErrorMessage('Incorrect password');
      } else {
        showErrorMessage(e.code);
      }
    }
  }

  // error message to user
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return DefaultOneOptionDialog(
          title: message,
          content: '', //want to find a way to make this null...
          buttonText: 'Ok',
          onPressed: () => Navigator.pop(context),
        );

        /*CupertinoAlertDialog(
          title: Text(message),
          actions: [
            CupertinoDialogAction(
              child: TextButton(
                child: const Text('Ok'),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        );
      */
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  const Text(
                    'Postur',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 30,
                      color: absentRed,
                    ),
                  ),
                  const SizedBox(height: 50),

                  // Sign in
                  Text(
                    'Sign In:',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),

                  // username textfeild
                  MyTextField(
                    controller: emailController,
                    hintText: 'College email',
                    obscureText: false,
                  ),
                  const SizedBox(height: 15),
                  // password texfield
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),

                  // forgot password?
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Forgot password?',
                          style: TextStyle(
                            color: neutralGrey,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  //Sign in button
                  MyButton(onTap: signUserIn, text: 'Sign In'),
                  const SizedBox(height: 30),

                  //Divider
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.6,
                            color: Color.fromARGB(255, 215, 215, 215),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'New Here?',
                            style: TextStyle(
                              color: Color.fromARGB(255, 91, 91, 91),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.6,
                            color: Color.fromARGB(255, 215, 215, 215),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 35),

                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
