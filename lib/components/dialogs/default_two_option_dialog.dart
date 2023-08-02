import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefaultTwoOptionDialog extends StatelessWidget {
  final String title;
  final String content;
  final String optionOneText;
  final String optionTwoText;
  final Function()? onOptionOne; // Perhaps increase the specificity of this, by
  final Function()? onOptionTwo; // specifying precise function type
  const DefaultTwoOptionDialog({
    super.key,
    required this.title,
    this.content = '',
    required this.optionOneText,
    required this.optionTwoText,
    required this.onOptionOne,
    required this.onOptionTwo,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: onOptionOne, // This is the not bold option
          child: Text(
            optionOneText,
            style: const TextStyle(color: Colors.blue),
          ),
        ),
        TextButton(
          onPressed: onOptionTwo, // This is the bold option
          child: Text(
            optionTwoText,
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
