import 'package:auth_test/pages/scan_result.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRView extends StatefulWidget {
  const QRView({super.key});

  @override
  State<QRView> createState() => _QRViewState();
}

class _QRViewState extends State<QRView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  // Barcode? result;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  
  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      controller: MobileScannerController(
        facing: CameraFacing.back,
        detectionTimeoutMs: 2000,
      ),
      onDetect: (capture) {
        final List<Barcode> barcodes = capture.barcodes;
        int numCodes = barcodes.length;
        Navigator.push(
        context,
          MaterialPageRoute(
            builder: (context) => const ScanResultPage()));
      },
    );
  }
}
