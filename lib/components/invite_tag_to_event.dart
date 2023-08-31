import 'package:auth_test/src/colors.dart';
import 'package:flutter/material.dart';

class InviteTagToEventEntry extends StatelessWidget {
  final Map<String, dynamic> tag; //must have keys 'tagTitle' and 'tagId';
  final void Function() onSelect; // should be a function that accepts no args!
  final void Function()
      onDeselect; // should be a function that accepts no args!
  final bool selected;

  const InviteTagToEventEntry({
    super.key,
    required this.tag,
    required this.onSelect,
    required this.onDeselect,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        selected ? onDeselect() : onSelect();
      },
      child: Container(
        decoration: attendingBoxDecoration(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          children: [
            const Icon(
              Icons.circle,
              color: Colors.black,
              size: 50,
            ),
            const SizedBox(
              width: 7,
            ),
            Text(
              "#${tag['tagTitle']}",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Icon(
                      selected ? Icons.check_circle : Icons.circle_outlined,
                      color: attendingOrange,
                    ),
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

BoxDecoration attendingBoxDecoration() {
  return const BoxDecoration(
    border: Border(
        bottom: BorderSide(
      color: Color.fromARGB(255, 230, 230, 229),
      width: 1.0,
    )),
  );
}
