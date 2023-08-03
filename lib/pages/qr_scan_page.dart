// import 'package:auth_test/pages/home_page.dart';
// import 'package:auth_test/pages/profile_page.dart';
import 'package:auth_test/src/colors.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';

import '../components/qr_scan_widget.dart';

class QRScanPage extends StatelessWidget {
  const QRScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: absentRed,
          )
        ),
        title: const Text(
          'Scan QR Code',
          style: TextStyle(
            color: absentRed,
            fontWeight: FontWeight.bold,
          )
        )
      ),
      body: const QRView()
    );
  }
}
