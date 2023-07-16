import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import '../src/colors.dart';

class IDWidget extends StatelessWidget {
  final String fullName;
  final String userName;

  const IDWidget({
    super.key,
    required this.fullName,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
      child: Column(
        children: [
          QrImageView(
            data: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
            size: 200,
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: absentRed,
            ),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: absentRed,
            ),
          ),
          //Below was a test for rendering of custom marker widget
          //Feel free to delete if need be
          /* const MyMarkerWidget(
            isMember: true,
            eventTitle: 'Taco Tuesday',
          ), */
          Text(fullName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: absentRed,
              )),
          Text(
            '@$userName',
            style: const TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }
}
