import 'package:flutter/material.dart';

// This modal appears to confirm the change of a user's profile picture
class ProfilePicConfirm extends StatelessWidget {
  final String imageURL;

  const ProfilePicConfirm({
    super.key,
    required this.imageURL,
  });

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Column(
        children: [
          Image.network(imageURL),
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
            child: const Text("Yes",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(
            width: 10.0,
          ),
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
