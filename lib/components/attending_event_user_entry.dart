import 'package:flutter/material.dart';

BoxDecoration attendingBoxDecoration() {
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

class AttendingEventUserEntry extends StatelessWidget {
  final Map<String, String>
      user; // will ultimately be obtained from the User ID
  const AttendingEventUserEntry({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: attendingBoxDecoration(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          const Icon(
            Icons.circle, //User profile picture goes here...
            size: 50,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
            child: Text(
              user["name"]!,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

late bool isSelected;
late void Function() onTap;
