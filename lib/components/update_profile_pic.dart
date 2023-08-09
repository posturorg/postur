import 'dart:io';

import 'package:auth_test/src/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'modals/profile_pic_confirm.dart';

// Widget controlling the profile picture on the profile page
class UpdateProfilePic extends StatefulWidget {
  final String reference;
  final double radius;
  final double borderRadius;

  const UpdateProfilePic({
    super.key,
    required this.reference,
    required this.radius,
    required this.borderRadius,
  });

  @override
  State<UpdateProfilePic> createState() => _UpdateProfilePicState();
}

class _UpdateProfilePicState extends State<UpdateProfilePic> {

  // Retrieve user ID
  String uid = FirebaseAuth.instance.currentUser!.uid;
  
  // Initialize imageURL
  String imageURL = '';

  // This function allows the user to choose a profile pic to upload to Firebase Storage
  Future uploadProfilePic(context) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 200,
      maxHeight: 200,
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
          oldReference: widget.reference,
          imageURL: imageURL,
        ),
        barrierDismissible: false,
      );

    } catch(error) {
        // If an error occurs
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Icon(
          Icons.circle_outlined,
          color: absentRed,
          size: widget.borderRadius,
        ),
        IconButton(
          onPressed: () async {
            uploadProfilePic(context);
          },
          // If no profile image is set, display stock image
          icon: widget.reference == '' ? 
            CircleAvatar(
              backgroundImage: const AssetImage('lib/assets/thumbtack.png'),
              radius: widget.radius,
              // Else, show profile picture
            ) : CircleAvatar(
              radius: widget.radius,
              backgroundImage: NetworkImage(widget.reference)
            ),
        ),
      ]
    );
  }
}