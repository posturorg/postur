import 'package:auth_test/src/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:flutter/services.dart';

import 'qr_scan_widget.dart';

class ScanResult extends StatelessWidget {
  const ScanResult({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
              title: const Text(
                  'Alvin is on the list'
                  ),
              content: IconButton(
                icon: const Icon(Icons.check_circle, color: Colors.green),
                onPressed: () {
                  Navigator.pop(context);
                },
                iconSize: 200,
              ),
              actions: [
            TextButton(
                onPressed: () =>
                    Navigator.pop(
                        context),
                child: const Text(
                    "OK",
                    style: TextStyle(
                      color:
                          Colors.blue,
                    ))),
              ]);
  }
}
