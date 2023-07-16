import 'package:flutter/material.dart';

class ModalBottomButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final Color backgroundColor;

  const ModalBottomButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        elevation: 0.0,
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
