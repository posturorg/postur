import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import '../src/colors.dart';

class IDWidget extends StatelessWidget {
  final String fullName;
  final String userName;
  final String uid;

  const IDWidget({
    super.key,
    required this.fullName,
    required this.userName,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return QrImageView(
      data: uid,
      size: 165,
      eyeStyle: const QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: absentRed,
      ),
      dataModuleStyle: const QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: absentRed,
      ),
    );
  }
}
