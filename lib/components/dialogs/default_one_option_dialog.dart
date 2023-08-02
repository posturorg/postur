import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefaultOneOptionDialog extends StatelessWidget {
  final String title;
  final String content;
  final String buttonText;
  final Function()? onPressed;

  const DefaultOneOptionDialog({
    super.key,
    required this.title,
    this.content = '',
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    //This might be a bit verbose...
    if (content == '') {
      return CupertinoAlertDialog(
        title: Text(title),
        actions: [
          CupertinoDialogAction(
            child: TextButton(
              onPressed: onPressed,
              child: Text(buttonText),
            ),
          ),
        ],
      );
    } else {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          CupertinoDialogAction(
            child: TextButton(
              onPressed: onPressed,
              child: Text(buttonText),
            ),
          ),
        ],
      );
    }
  }
}
