import 'package:auth_test/src/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:flutter/services.dart';

import 'qr_scan_widget.dart';

class ScanResult extends StatelessWidget {
  final String fullName;
  final bool isMember;

  const ScanResult({
    super.key,
    required this.fullName,
    required this.isMember,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
              title: Text(
                  isMember ? '$fullName is on the list.' : '$fullName is NOT the list.'
                  ),
              content: IconButton(
                icon: isMember ? const Icon(Icons.check_circle, color: Colors.green) : const Icon(Icons.cancel, color: absentRed),
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
