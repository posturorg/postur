import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// This modal appears to confirm the change of a user's profile picture
class ProfilePicConfirm extends StatefulWidget {
  final String imageURL;

  const ProfilePicConfirm({
    super.key,
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
    .then((value) => print("user updated"))
    .catchError((error) => print("failed to update profile picture: $error"));
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Column(
        children: [
          Image.network(widget.imageURL),
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

              /* TODO: If there is a current reference in Firestore, delete it's image from Storage */
              
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
            child: const Text("Yes",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(
            width: 10.0,
          ),
          // No Button
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              padding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
              // backgroundColor: backgroundWhite,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 0.0,
            ),
            child: const Text("No",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
