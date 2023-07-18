import 'package:auth_test/components/event_details_modal.dart';
import 'package:flutter/cupertino.dart';

import '../src/colors.dart';
import 'package:flutter/material.dart';

class YourEventWidget extends StatelessWidget {
  final String eventTitle;
  final String eventCreator;
  final bool isCreator;
  final bool isMember;
  //final bool isCreator;
  //final bool isMember;

  const YourEventWidget({super.key, 
    required this.eventTitle,
    required this.eventCreator,
    required this.isCreator,
    required this.isMember,
  });

  BoxDecoration tagBoxDecoration() {
    return const BoxDecoration(
      border: Border(
          bottom: BorderSide(
        color: backgroundWhite,
        width: 1.0,
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //print("$eventTitle details");
        showModalBottomSheet<void>(
          // context and builder are
          // required properties in this widget
          context: context,
          isScrollControlled: true,
          elevation: 0.0,
          backgroundColor: Colors.white,
          clipBehavior: Clip.antiAlias,
          showDragHandle: true,
          builder: (BuildContext context) {
            // we set up a container inside which
            // we create center column and display text

            // Returning SizedBox instead of a Container
            return EventDetailsModal(
              eventTitle: eventTitle,
              eventCreator: eventCreator,
              isCreator: isCreator,
              isMember: isMember,
            );
          },
        );
      },
      child: Container(
        decoration: tagBoxDecoration(),
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: Row(
          children: [
            Icon(
              Icons.circle,
              size: 50,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(7, 0, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(eventTitle,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  Text(eventCreator,
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 93, 93, 93),
                      ))
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet<void>(
                        // context and builder are
                        // required properties in this widget
                        context: context,
                        isScrollControlled: true,
                        elevation: 0.0,
                        backgroundColor: Colors.white,
                        clipBehavior: Clip.antiAlias,
                        showDragHandle: true,
                        builder: (BuildContext context) {
                          // we set up a container inside which
                          // we create center column and display text

                          // Returning SizedBox instead of a Container
                          return SizedBox(
                            height: 750,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    Icons.circle,
                                    size: 85,
                                  ),
                                  Text(
                                    eventTitle,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 255, 157, 0),
                                    ),
                                  ),
                                  Container(
                                    decoration: tagBoxDecoration(),
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('Creator: $eventCreator',
                                            style: TextStyle(
                                              fontSize: 17,
                                            )),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text('When:',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            )),
                                        SizedBox(width: 8.0),
                                        Expanded(
                                          child: SizedBox(
                                            width: 200.0,
                                            height: 50.0,
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                hintText:
                                                    'This Wednesday, 7:30 p.m.',
                                                border:
                                                    OutlineInputBorder(), // Customize the border style
                                              ),
                                              onChanged: (value) {
                                                // Handle the text input change
                                                // ...
                                              },
                                              validator: (value) {
                                                // Perform form validation and return an error message if necessary
                                                // ...
                                                return null; // Return null to indicate no validation errors
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text('Ends:',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            )),
                                        SizedBox(width: 8.0),
                                        Expanded(
                                          child: SizedBox(
                                            width: 200.0,
                                            height: 50.0,
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                hintText: '10 p.m.',
                                                border:
                                                    OutlineInputBorder(), // Customize the border style
                                              ),
                                              onChanged: (value) {
                                                // Handle the text input change
                                                // ...
                                              },
                                              validator: (value) {
                                                // Perform form validation and return an error message if necessary
                                                // ...
                                                return null; // Return null to indicate no validation errors
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text('RSVP by:',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            )),
                                        SizedBox(width: 8.0),
                                        Expanded(
                                          child: SizedBox(
                                            width: 200.0,
                                            height: 50.0,
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                hintText:
                                                    'This Tuesday, 10 a.m.',
                                                border:
                                                    OutlineInputBorder(), // Customize the border style
                                              ),
                                              onChanged: (value) {
                                                // Handle the text input change
                                                // ...
                                              },
                                              validator: (value) {
                                                // Perform form validation and return an error message if necessary
                                                // ...
                                                return null; // Return null to indicate no validation errors
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text('Where:',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            )),
                                        SizedBox(width: 8.0),
                                        Expanded(
                                          child: SizedBox(
                                            width: 200.0,
                                            height: 50.0,
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                hintText:
                                                    '901 Fictitious Square, Unreal City, USA 67890',
                                                border:
                                                    OutlineInputBorder(), // Customize the border style
                                              ),
                                              onChanged: (value) {
                                                // Handle the text input change
                                                // ...
                                              },
                                              validator: (value) {
                                                // Perform form validation and return an error message if necessary
                                                // ...
                                                return null; // Return null to indicate no validation errors
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: RichText(
                                            text: TextSpan(
                                              style: DefaultTextStyle.of(
                                                      context)
                                                  .style, // Use the default text style from the context
                                              children: [
                                                TextSpan(
                                                  text: 'Attending: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15),
                                                ),
                                                TextSpan(
                                                  text:
                                                      'Thomas Kowalski, William Gödeler',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 15),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text('Description:',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            )),
                                        SizedBox(width: 8.0),
                                        Expanded(
                                          child: SizedBox(
                                            width: 200.0,
                                            height: 50.0,
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                hintText:
                                                    'Never gonna give you up, never gonna let you down, never gonna run around and desert you.',
                                                border:
                                                    OutlineInputBorder(), // Customize the border style
                                              ),
                                              onChanged: (value) {
                                                // Handle the text input change
                                                // ...
                                              },
                                              validator: (value) {
                                                // Perform form validation and return an error message if necessary
                                                // ...
                                                return null; // Return null to indicate no validation errors
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: SafeArea(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (_) =>
                                                    CupertinoAlertDialog(
                                                        title: const Text(
                                                            'Are you sure?'),
                                                        content: Text(
                                                            'Do you really want to cancel #$eventTitle?'),
                                                        actions: [
                                                      TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context),
                                                          child: const Text(
                                                              "No, don't cancel",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.blue,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ))),
                                                      TextButton(
                                                          onPressed: () {},
                                                          child: const Text(
                                                              "Yes, cancel",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blue))),
                                                    ]),
                                                barrierDismissible: true,
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8, horizontal: 14),
                                              backgroundColor: Color.fromARGB(
                                                  255, 255, 17, 0),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          13)),
                                              elevation: 0.0,
                                            ),
                                            child: Text('Cancel $eventTitle',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      backgroundColor: Color.fromARGB(255, 95, 95, 95),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 0.0,
                    ),
                    child: Text('Edit',
                        style: TextStyle(
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => CupertinoAlertDialog(
                            title: Text('Are you sure?'),
                            content: Text(
                                'Do you really want to cancel $eventTitle?'),
                            actions: [
                              TextButton(
                                  onPressed: () {},
                                  child: Text("Yes, poop the party.",
                                      style: TextStyle(color: Colors.blue))),
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("No, party on!",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ))),
                            ]),
                        barrierDismissible: true,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      backgroundColor: Color.fromARGB(255, 255, 157, 0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 0.0,
                    ),
                    child: Text('Cancel',
                        style: TextStyle(
                          color: Colors.white,
                        )),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
