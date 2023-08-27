import 'package:auth_test/src/colors.dart';
import 'package:flutter/material.dart';

class InviteToEventEntry extends StatelessWidget {
  final Map<String, dynamic> user;
  final void Function() onSelect; // should be a function that accepts no args!
  final void Function() onDeselect; //should be a function that accepts no args!
  final bool selected;
  const InviteToEventEntry({
    super.key,
    required this.user, //must have keys 'first', 'last', 'username', & 'userID',
    //ultimately, user will just be replaced with userId,
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
            CircleAvatar(
              //fix this...
              radius: 24,
              backgroundImage: NetworkImage(user['profile_pic']),
            ), //Profile pic goes here
            const SizedBox(
              width: 7,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${user['name']['first']} ${user['name']['last']}",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("@${user['username']}"),
              ],
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
