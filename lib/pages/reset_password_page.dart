import 'package:auth_test/src/colors.dart';
import 'package:flutter/material.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

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
          'Title',
          style: TextStyle(
            color: absentRed,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
