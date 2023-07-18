import 'package:auth_test/components/scan_result_modal.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRView extends StatefulWidget {
  
  const QRView({super.key,});

  @override
  State<QRView> createState() => _QRViewState();
}

class _QRViewState extends State<QRView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  
  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      controller: MobileScannerController(
        facing: CameraFacing.back,
        detectionSpeed: DetectionSpeed.noDuplicates,
      ),
      onDetect: (capture) {
        final List<Barcode> barcodes = capture.barcodes;
        showDialog(
          context: context,
          builder: (_) => const ScanResult(
            fullName: 'Alvin', isMember: false),
            barrierDismissible: true,
        );
      },
    );
  }
}
