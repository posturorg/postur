import '../src/colors.dart';
import '../src/date_time_utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateEventDateTime extends StatefulWidget {
  //Need to add a constructor for latest time allowed and
  //for default what the default time will be set to
  const CreateEventDateTime({super.key});

  @override
  State<CreateEventDateTime> createState() => _CreateEventDateTimeState();
}

class _CreateEventDateTimeState extends State<CreateEventDateTime> {
  final DateTime minimumDateTime = DateTime.now();
  DateTime defaultDateTime =
      DateTime.now(); // This should be present time, or null (sort of)
  DateTime maximumDateTime = DateTime.now().add(const Duration(days: 14));

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      child: CupertinoButton(
        child: Text(
            //Need to add some kind of border around this to indicate that it is an interactable button.
            '${monthList[defaultDateTime.month - 1]} ${defaultDateTime.day}, ${hourRectifier(defaultDateTime.hour)}:${defaultDateTime.minute} ${amPmString(defaultDateTime.hour)}',
            style: TextStyle(color: Colors.grey.shade800)),
        onPressed: () {
          showCupertinoModalPopup(
            context: context,
            builder: (BuildContext context) => SizedBox(
              height: 250,
              child: CupertinoDatePicker(
                backgroundColor: backgroundWhite,
                initialDateTime:
                    defaultDateTime, //Should be device time or current time (via internet)
                onDateTimeChanged: (DateTime newTime) {
                  setState(() => defaultDateTime = newTime);
                },
                minimumDate: minimumDateTime,
                maximumDate: maximumDateTime,
              ),
            ),
          );
        },
      ),
    );
  }
}
