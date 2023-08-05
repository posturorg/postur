import 'package:flutter/material.dart';

// Widget controlling the profile picture on the profile page
class ProfilePic extends StatelessWidget {
  const ProfilePic({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {}, 
      icon: const Icon(
        Icons.circle_outlined,
        color: Colors.black,
        size: 80,
      )
    );
  }
}