import 'package:auth_test/components/dialogs/default_one_option_dialog.dart';
import 'package:auth_test/components/my_button.dart';
import 'package:auth_test/components/my_textfield.dart';
import 'package:auth_test/src/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPasswordPage extends StatefulWidget {
  ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController emailResetController = TextEditingController();

  Future resetPassword() async {
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
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailResetController.text.trim(),
      ); //also need to check for errors and act accordingly
      Navigator.pop(context); // pops loading circle
      showDialog(
        context: context,
        builder: (context) => DefaultOneOptionDialog(
          title: 'Reset password email sent...',
          content: 'Please check your email.',
          buttonText: 'Ok',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      );
    } catch (e) {
      Navigator.pop(context); // pops loading circle
      showDialog(
        context: context,
        builder: (context) => DefaultOneOptionDialog(
          title: e.toString(),
          buttonText: 'Ok',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: absentRed,
            ),
            onPressed: () {
              Navigator.pop(context); //closes page
            },
          ),
          title: const Text(
            'Reset Password',
            style: TextStyle(
              color: absentRed,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyTextField(
                  controller: emailResetController,
                  hintText: 'College Email',
                  obscureText: false,
                ),
                const SizedBox(height: 30),
                MyButton(onTap: resetPassword, text: 'Reset Password'),
              ],
            ),
          ),
        ));
  }
}
