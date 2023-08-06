import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'modals/profile_pic_confirm.dart';

// Widget controlling the profile picture on the profile page
class ProfilePic extends StatefulWidget {
  const ProfilePic({super.key});

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  // Initialize imageURL
  String imageURL = '';

  // Retrieve user ID
  String uid = FirebaseAuth.instance.currentUser!.uid;
  // Retrieve user data in order to update it later
  CollectionReference? users = FirebaseFirestore.instance.collection('Users');

  // This function allows the user to choose a profile pic to upload to Firebase Storage
  Future uploadProfilePic(context) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 256,
      maxHeight: 256,
      imageQuality: 75
    );
    
    if (file==null) {
      return;
    }

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    // Upload to Firebase Storage
    // Get reference to firebase storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    // Get reference to directory within firebase storage root
    Reference referenceDirImages = referenceRoot.child('profile_pictures');

    // Create reference for image to be stored
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    // Handle successes/errors
    try {
      
      // Store the image file
      await referenceImageToUpload.putFile(File(file.path));

      // Success
      imageURL = await referenceImageToUpload.getDownloadURL();

      // Summon confirmation modal
      showDialog(
        context: context,
        builder: (_) => ProfilePicConfirm(
          imageURL: imageURL,
        ),
        barrierDismissible: false,
      );

    } catch(error) {
        // An error occurs
        return;
    }
  }
  
  // This function updates the imageURL in Firestore
  Future updateProfilePic(String imageURL)  {
    return users!.doc(uid).update({
      'profile picture': imageURL,
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        uploadProfilePic(context);
      },
      /* TODO: Make circular profile picture widget */
      // If the picture has been downloaded, display profile picture
      icon: imageURL == '' ? const Icon(
        Icons.circle_outlined,
        color: Colors.black,
        size: 80,
      ) : Image.network(imageURL),
    );
  }
}