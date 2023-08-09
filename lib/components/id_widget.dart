import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../src/colors.dart';
import './qr_code.dart';
import './profile_pic.dart';

class IDWidget extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> currentUser;

  const IDWidget ({
    super.key,
    required this.currentUser,
  });

  @override
  State<IDWidget> createState() => _IDWidgetState();
}

class _IDWidgetState extends State<IDWidget> {

  // Retrieve user data from Firestore
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // QR Code with value of uid
        QRCodeWidget(
          uid: widget.currentUser['uid'],
        ),
        // Profile Picture
        ProfilePic(reference: widget.currentUser['profile_pic']),
        // Full Name
        Text(
          "${widget.currentUser['first_name']} ${widget.currentUser['last_name']}",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: absentRed,
          )
        ),
            // Username
        Text(
          widget.currentUser['email'],
          style: const TextStyle(fontSize: 15),
        ),
      ],
    );
  }
}
