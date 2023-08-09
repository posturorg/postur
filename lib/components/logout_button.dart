import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../src/colors.dart'; 

class LogOutButton extends StatelessWidget {
  final bool isOnProfilePage;

  const LogOutButton({
    super.key,
    required this.isOnProfilePage
  });

  @override
  Widget build(BuildContext context){
    return Visibility(
      visible: isOnProfilePage,
      child: IconButton(
        icon: const Icon(
          Icons.logout,
          color: absentRed,
          size: 27
        ),
        onPressed: () {
          FirebaseAuth.instance.signOut();
        },
      ),
    );
  }
}