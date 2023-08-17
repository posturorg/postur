import 'package:auth_test/pages/qr_scan_page.dart';
import 'package:auth_test/src/colors.dart';
import 'package:flutter/material.dart';

class ScanEventEntry extends StatelessWidget {
  final String eventId;
  final String eventTitle;
  
  const ScanEventEntry({
    super.key,
    required this.eventId,
    required this.eventTitle,
  });

  BoxDecoration eventBoxDecoration() {
    return const BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Colors.black,
          width: 1.0,
        ),
      ),
    );
  }

  final double fromTopAndBottom = 15.0; //Essentially encodes vertical size of box

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QRScanPage(eventId: eventId),
          ),
        );
      }, // navigate to qr code scanner
      child: Container(
        //copy this into address autocomplete modal
        padding: EdgeInsets.fromLTRB(0, fromTopAndBottom, 0, fromTopAndBottom),
        decoration: eventBoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(7, 0, 7, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  eventTitle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: absentRed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
