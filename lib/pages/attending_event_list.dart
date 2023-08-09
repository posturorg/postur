import 'package:auth_test/components/my_searchbar.dart';
import 'package:auth_test/pages/attending_event_user_entry.dart';
import 'package:auth_test/src/colors.dart';
import 'package:flutter/material.dart';

class AttendingEventList extends StatelessWidget {
  const AttendingEventList({super.key});

  @override
  Widget build(BuildContext context) {
    Color detailsColor = absentRed;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Attending',
          style: TextStyle(
            color: detailsColor,
            fontWeight: FontWeight.bold,
            fontSize: 21.5,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: detailsColor, //this should be a function of a parameter of
            //the widget, depending on if the user is already attending.
          ),
        ),
      ),
      body: const Column(
        children: [
          const MySearchBar(),
          const Divider(color: Color.fromARGB(255, 230, 230, 229)),
          AttendingEventUserEntry(
            isEditing: false,
            displayName: 'Ben duPont',
          ),
          /*
          ListView.builder(
            itemBuilder: (context, index) {
              []; //this will be a variable contained in the state
            },
          )*/
        ],
      ),
    );
  }
}
