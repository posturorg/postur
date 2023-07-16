/* a special type of button specifically used for in line needs, like in tags
menus */

import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';

class MyInlineButton extends StatelessWidget {
  final Color color;
  final String text;
  final Function()? onTap;

  const MyInlineButton({
    super.key,
    required this.color,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0.0,
      ),
      child: Text(text,
          style: const TextStyle(
            color: Colors.white,
          )),
    );
  }
}
