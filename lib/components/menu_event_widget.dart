import 'package:auth_test/components/modals/event_create_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'modals/event_details_modal.dart';
import '../src/colors.dart';

class MenuEventWidget extends StatelessWidget {
  final String eventTitle;
  final String eventCreator;
  final bool isCreator;
  final bool isMember;

  MenuEventWidget({
    super.key,
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String mainButtonText;
    if (isCreator) {
      mainButtonText = 'Cancel';
    } else if (isMember) {
      mainButtonText = 'Leave';
    } else {
      mainButtonText = 'RSVP';
    }

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
        // This is the actual display part of the "in list" event
        decoration: tagBoxDecoration(),
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: Row(
          children: [
            const Icon(
              Icons.circle,
              size: 50,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(7, 0, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(eventTitle,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                  Text(
                    isCreator ? 'Me' : eventCreator,
                    style: const TextStyle(
                      fontSize: 15,
                      color: neutralGrey,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Visibility(
                    visible: isCreator,
                    child: ElevatedButton(
                      //Edit button... Should make this an instance of another widget...
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

                            return const EventCreateModal(
                                exists:
                                    true); //Need to make this a bit more general... with a leave button
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 10),
                        backgroundColor: neutralGrey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 0.0,
                      ),
                      child: const Text(
                        'Edit',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
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
                        //Need to compress this
                        context: context,
                        builder: (_) => CupertinoAlertDialog(
                          title: const Text('Are you sure?'),
                          content:
                              Text('Do you really want to cancel $eventTitle?'),
                          actions: [
                            TextButton(
                                onPressed: () {},
                                child: const Text("Yes, poop the party.",
                                    style: TextStyle(color: Colors.blue))),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                "No, party on!",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        barrierDismissible: true,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 10),
                      backgroundColor: isMember ? attendingOrange : absentRed,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 0.0,
                    ),
                    child: Text(
                      mainButtonText,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
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
