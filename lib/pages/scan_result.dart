import 'package:auth_test/src/colors.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:flutter/services.dart';

import '../components/qr_scan_widget.dart';

class ScanResultPage extends StatelessWidget {
  const ScanResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Center(
        child:
          IconButton(
            icon: const Icon(Icons.check_circle, color: Colors.green),
            onPressed: () {
              Navigator.pop(context);
            },
            iconSize: 300,
          )
      ),
    );
  }
}
