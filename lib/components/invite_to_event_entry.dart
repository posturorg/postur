import 'package:auth_test/src/colors.dart';
import 'package:flutter/material.dart';

class InviteToEventEntry extends StatefulWidget {
  final Map<String, dynamic> user; //will ultimately just be a string (uid).
  final dynamic onSelect; // should be a function that accepts no args!
  final dynamic onDeselect; //should be a function that accepts no args!
  final bool
      defaultSelected; //determines whether or not this is selected by default
  const InviteToEventEntry({
    super.key,
    required this.user, //must have keys 'first', 'last', 'username', & 'userID',
    //ultimately, user will just be replaced with userId,
    this.onSelect,
    this.onDeselect,
    this.defaultSelected = false,
  });

  @override
  State<InviteToEventEntry> createState() => _InviteToEventEntryState();
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

class _InviteToEventEntryState extends State<InviteToEventEntry> {
  bool selected = false;

  @override
  void initState() {
    super.initState();
    selected = widget.defaultSelected;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (selected) {
          //this is the act of "deselecting"
          setState(() {
            selected = false;
          });
          widget.onDeselect();
        } else {
          setState(() {
            selected = true;
          });
          widget.onSelect();
        }
      },
      child: Container(
        decoration: attendingBoxDecoration(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          children: [
            const Icon(
              Icons.circle,
              size: 50,
            ), //Profile pic goes here
            const SizedBox(
              width: 7,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.user['name']['first']} ${widget.user['name']['last']}",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("@${widget.user['username']}"),
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
