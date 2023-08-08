import 'package:flutter/material.dart';

import '../src/colors.dart';
import './qr_code.dart';
import './profile_pic.dart';

class IDWidget extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String userName;
  final String reference;
  final String uid;

  const IDWidget ({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.reference,
    required this.uid,
  });

  @override
  State<IDWidget> createState() => _IDWidgetState();
}

class _IDWidgetState extends State<IDWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // QR Code with value of uid
        QRCodeWidget(
          uid: widget.uid,
        ),
        // Profile Picture
        ProfilePic(reference: widget.reference),
        // Full Name
        Text(
          '${widget.firstName} ${widget.lastName}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: absentRed,
          )
        ),
        // Username
        Text(
          widget.userName,
          style: const TextStyle(fontSize: 15),
        ),
      ],
    );
  }
}