import 'package:auth_test/src/colors.dart';
import 'package:flutter/material.dart';

class ChatWidget extends StatelessWidget {
  late final String chatTitle;

  ChatWidget({
    required this.chatTitle,
  });

  BoxDecoration chatBoxDecoration() {
    return const BoxDecoration(
      border: Border(
          /*top: BorderSide(
            color: Color.fromARGB(255, 230, 230, 229),
            width: 1.0,
          ),*/
          bottom: BorderSide(
        color: Color.fromARGB(255, 230, 230, 229),
        width: 1.0,
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("Open $chatTitle");
      },
      child: Container(
        decoration: chatBoxDecoration(),
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: Row(
          children: [
            const Icon(
              Icons.circle,
              size: 50,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(7, 0, 185, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chatTitle,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    Icons.arrow_forward_ios,
                    color: absentRed,
                    size: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
