import 'package:auth_test/src/colors.dart';
import 'package:flutter/material.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //leading: ,
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
