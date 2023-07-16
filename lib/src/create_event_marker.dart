import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../src/colors.dart';
import '../src/pin_svg_strings.dart';

Future<BitmapDescriptor> createEventMarker(
  //Need to add "vibe" emoji argument.
  BuildContext context,
  String eventTitle,
  bool isMember,
) async {
  final String svgMarkerString =
      isMember ? orangePinStringSVG : redPinStringSVG;

  final Color colorPaint = isMember ? attendingOrange : absentRed;

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);

  // Set up the text style
  final textStyle = TextStyle(
    color: colorPaint, // Set the text color to red
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  // Determine the text size and position
  final textSpan = TextSpan(text: eventTitle, style: textStyle);
  final textPainter = TextPainter(
    text: textSpan,
    textDirection: TextDirection.ltr,
  );
  textPainter.layout();

  // Draw the text on the canvas
  textPainter.paint(canvas, const Offset(0, 0));

  // -- End the recording and obtain the picture --
  final picture = recorder.endRecording();

  // Convert the picture to a PNG byte data
  final image = await picture.toImage(
    textPainter.width.toInt(),
    textPainter.height.toInt(),
  );
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  final bytes = Uint8List.view(byteData!.buffer);

  // Create and return the BitmapDescriptor
  return BitmapDescriptor.fromBytes(bytes);
}
