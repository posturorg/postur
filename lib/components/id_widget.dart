import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../src/colors.dart';
import './qr_code.dart';
import 'update_profile_pic.dart';

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

  // Retrieve uid of current user
  String uid = FirebaseAuth.instance.currentUser!.uid;

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
        UpdateProfilePic(reference: widget.currentUser['profile_pic'], radius: 45, borderRadius: 115),
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
 
// Widget that streams current user data to ID widget
class IDStream extends StatefulWidget {
  final Query<Map<String, dynamic>> currentUser;

  const IDStream ({
    super.key,
    required this.currentUser,
  });

  @override
  State<IDStream> createState() => _IDStreamState();
}

class _IDStreamState extends State<IDStream> {
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.currentUser.snapshots(),
      builder: (context, snapshot) {
        // What to show if waiting for data
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show Waiting Indicator
          return const Center(child: CircularProgressIndicator(color: absentRed));

        // What to show if data has been received
        } else if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
          // Potenital error message
          if (snapshot.hasError) {
            return const Center(child: Text("Error Occured"));
          // Success
          } else if (snapshot.hasData) {  
            /* Access current user's data from streams */
            final currentUserData = snapshot.data!.docs[0];
            return IDWidget(currentUser: currentUserData,);
          }
          return const Center(child: Text("No Data Received"));
        }
        return Center(child: Text(snapshot.connectionState.toString()));
      }
    );
  }
}
