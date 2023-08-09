import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'modals/profile_pic_confirm.dart';

// Widget controlling the profile picture on the profile page
class ProfilePic extends StatefulWidget {
  final String reference;

  const ProfilePic({
    super.key,
    required this.reference,
  });

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {

  // Retrieve user ID
  String uid = FirebaseAuth.instance.currentUser!.uid;
  
  // Initialize imageURL
  String imageURL = '';

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

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        uploadProfilePic(context);
      },
      /* TODO: Make circular profile picture widget */
      // If the picture has been downloaded, display profile picture
      icon: Image.network(widget.reference),
    );
  }
}