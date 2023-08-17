import 'package:auth_test/src/colors.dart';
import 'package:flutter/material.dart';

class InternalSplashScreen extends StatelessWidget {
  const InternalSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Postur',
          style: TextStyle(
            color: absentRed,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
    );
  }
}
