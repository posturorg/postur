import 'package:auth_test/components/modals/scan_result_modal.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRView extends StatefulWidget {
  final String eventId;
  
  const QRView({
    super.key,
    required this.eventId,
    });

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
        String? userId = barcodes[0].rawValue;
        print(userId);
        showDialog(
          context: context,
          builder: (_) => ScanResult(
            eventId: widget.eventId,
            userId: userId,
          ),
            barrierDismissible: true,
        );
      },
    );
  }
}
