import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

// This modal appears to confirm the change of a user's profile picture
class ProfilePicConfirm extends StatefulWidget {
  final String oldReference;
  final String imageURL;

  const ProfilePicConfirm({
    super.key,
    required this.oldReference,
    required this.imageURL,
  });

  @override
  State<ProfilePicConfirm> createState() => _ProfilePicConfirmState();
}

class _ProfilePicConfirmState extends State<ProfilePicConfirm> {

  // Retrieve user ID
  String uid = FirebaseAuth.instance.currentUser!.uid;

  // Retrieve user data in order to update it in Firestore
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  
  // This function updates the imageURL in Firestore
  Future updateProfilePic(String imageURL)  {
    
    // Update profile pic using "update" function
    return users.doc(uid).update({
      'profile_pic': imageURL,
    })
    .then((value) => print("user updated profile picture"))
    .catchError((error) => print("failed to update profile picture: $error"));
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Column(
        children: [
          CircleAvatar(
            radius: 75,
            backgroundImage: NetworkImage(widget.imageURL),
          ),
          const Text(
            "Make this your new profile picture?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Yes button
          ElevatedButton(
            onPressed: () {
              
              // Delete the old profile image from Firebase storage
              if (widget.oldReference != '') {
                FirebaseStorage.instance.refFromURL(widget.oldReference).delete();
              }
              
              // Add image reference to current user's Firestore data
              updateProfilePic(widget.imageURL);
              
              // Close modal
              Navigator.pop(context);

            },
            style: ElevatedButton.styleFrom(
              padding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
              // backgroundColor: backgroundWhite,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 0.0,
            ),
            child: const Text("Yes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(
            width: 10.0,
          ),
          // No Button
          ElevatedButton(
            onPressed: () {
              // Delete selected image from Firebase Storage
              FirebaseStorage.instance.refFromURL(widget.imageURL).delete();
              // Close modal
              Navigator.pop(context);
              },
            style: ElevatedButton.styleFrom(
              padding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
              // backgroundColor: backgroundWhite,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 0.0,
            ),
            child: const Text("No", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
