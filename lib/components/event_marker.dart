import 'package:auth_test/src/colors.dart';
import 'package:auth_test/src/pin_svg_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EventMarker extends StatelessWidget {
  final bool isAttending;
  final String eventTitle;
  const EventMarker({
    super.key,
    required this.isAttending,
    required this.eventTitle,
  });

  @override
  Widget build(BuildContext context) {
    Color primaryColor = isAttending ? attendingOrange : absentRed;
    print('Marker build');
    return Column(
      children: [
        Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            SvgPicture.string(
              isAttending ? orangePinStringSVG : redPinStringSVG,
              width: 60, //feel free to change this
              height: 60, //feel free to change this
            ),
            const Icon(
              Icons.circle,
              size: 47,
              color: Colors.black,
            ),
          ],
        ),
        Text(
          eventTitle,
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 16, //Feel free to change this.
          ),
        ),
      ],
    );
  }
}
