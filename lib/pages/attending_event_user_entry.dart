import 'package:auth_test/src/colors.dart';
import 'package:flutter/material.dart';

BoxDecoration AttendingBoxDecoration() {
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

class AttendingEventUserEntry extends StatefulWidget {
  final String displayName; // will ultimately be obtained from the User ID
  final bool isEditing;
  final void Function()? externalOnTap; // for whatever, from the outside, you
  // want to run on tapping the given entry. Only runs if isEditing.
  const AttendingEventUserEntry({
    super.key,
    required this.isEditing,
    required this.displayName,
    this.externalOnTap,
  });

  @override
  State<AttendingEventUserEntry> createState() =>
      _AttendingEventUserEntryState();
}

late bool isSelected;
late void Function() onTap;

class _AttendingEventUserEntryState extends State<AttendingEventUserEntry> {
  @override
  void initState() {
    super.initState();
    isSelected = false;
    if (widget.isEditing) {
      onTap = () {
        setState(() {
          isSelected = !isSelected;
        });
        widget.externalOnTap;
      };
    } else {
      onTap = () {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: AttendingBoxDecoration(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          children: [
            const Icon(
              Icons.circle,
              size: 50,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
              child: Text(
                widget.displayName,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                  child: Visibility(
                    visible: widget.isEditing,
                    child: Icon(
                      isSelected ? Icons.check_circle : Icons.circle_outlined,
                      color: attendingOrange,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
