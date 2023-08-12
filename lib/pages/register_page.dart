import 'package:auth_test/components/my_textfield.dart';
import 'package:auth_test/firestore.dart';
import 'package:auth_test/src/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auth_test/components/my_button.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // sign user up function
  void signUserUp() async {
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

    // try creating the user
    try {
      //check if password is the same as confirmed
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        User? updateUser = FirebaseAuth.instance.currentUser;
        updateUser!.updateEmail(emailController.text);
        userSetup(emailController.text);
        // Navigator.of(context).pushNamed(AppRoutes.menu) <-- from adding users to backend tutorial
      } else {
        // show error message, passwords do not match
        showErrorMessage("Passwords don't match");
      }
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
        return CupertinoAlertDialog(
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
                    'Sign Up:',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),

                  // email textfeild
                  MyTextField(
                    controller: emailController,
                    hintText: 'College email',
                    obscureText: false,
                  ),
                  const SizedBox(height: 10),

                  // password texfield
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),

                  // confirm password texfield
                  MyTextField(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),

                  const SizedBox(height: 20),

                  //Sign up button
                  MyButton(
                    onTap: signUserUp,
                    text: 'Sign Up',
                  ),
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
                            'Already have an account?',
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
                      'Sign In',
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
