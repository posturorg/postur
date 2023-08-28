import 'package:flutter/material.dart';

class InviteTagToEventEntry extends StatelessWidget {
  final Map<String, dynamic>
      tag; //must have keys 'name' and 'tagId' or equivalents
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
            const CircleAvatar(
              radius: 24,
              backgroundImage:
                  AssetImage('./assets/thumbtack.png'), //profile pic
            ),
            const SizedBox(
              width: 7,
            ),
            Text(
              "#${tag['name']}",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
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
