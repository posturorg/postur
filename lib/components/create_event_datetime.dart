//import '../src/colors.dart';
import '../src/colors.dart';
import '../src/date_time_utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateEventDateTime extends StatefulWidget {
  //Need to add a constructor for latest time allowed and
  //for default what the default time will be set to
  final String upperText;
  const CreateEventDateTime({super.key, this.upperText = ''});

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
    return CupertinoButton(
      child: Container(
        decoration: const BoxDecoration(
          color: backgroundWhite,
          borderRadius: BorderRadiusDirectional.all(
            Radius.circular(7),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Text(
            //Need to add some kind of border around this to indicate that it is an interactable button.
            '${dayList[defaultDateTime.weekday]}, ${monthList[defaultDateTime.month - 1]} ${defaultDateTime.day}, ${hourRectifier(defaultDateTime.hour)}:${(defaultDateTime.minute < 10) ? '0' + defaultDateTime.minute.toString() : defaultDateTime.minute.toString()} ${amPmString(defaultDateTime.hour)}',
            style: const TextStyle(
              color: Color.fromARGB(255, 128, 128, 128),
            ),
          ),
        ),
      ),
      onPressed: () {
        showModalBottomSheet(
          showDragHandle: true,
          context: context,
          builder: (BuildContext context) => Container(
            height: 280,
            child: Column(
              children: [
                Visibility(
                  visible: (widget.upperText != ''),
                  child: Text(
                    widget.upperText,
                    style: const TextStyle(
                      //Centralize these
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
                Expanded(
                  child: SafeArea(
                    child: CupertinoDatePicker(
                      backgroundColor: Colors.transparent,
                      initialDateTime:
                          defaultDateTime, //Should be device time or current time (via internet)
                      onDateTimeChanged: (DateTime newTime) {
                        setState(() => defaultDateTime = newTime);
                      },
                      minimumDate: minimumDateTime,
                      maximumDate: maximumDateTime,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
