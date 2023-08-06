import 'package:auth_test/components/dialogs/default_two_option_dialog.dart';
import 'package:auth_test/components/modals/event_create_modal.dart';
import 'package:auth_test/components/my_inline_button.dart';
import 'package:auth_test/src/places/places_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
    late String mainButtonText;
    late Function()? onMainButtonPress;
    if (isCreator) {
      mainButtonText = 'Cancel';
      onMainButtonPress = () => {
            showDialog(
              //Need to compress this
              context: context,
              builder: (_) => DefaultTwoOptionDialog(
                title: 'Are you sure?',
                content: 'Are you sure you want to cancel the event?',
                optionOneText: 'Yes, poop the party.',
                optionTwoText: 'No, party on!',
                onOptionOne: () {},
                onOptionTwo: () {
                  Navigator.pop(context);
                },
              ),
              barrierDismissible: true,
            )
          };
    } else if (isMember) {
      mainButtonText = 'Leave';
      onMainButtonPress = () => {
            showDialog(
              context: context,
              builder: (_) => DefaultTwoOptionDialog(
                title: 'Are you sure?',
                content: 'Are you sure you want to leave the event?',
                optionOneText: 'Yes, leave.',
                optionTwoText: 'No, stay.',
                onOptionOne: () {},
                onOptionTwo: () {
                  Navigator.pop(context);
                },
              ),
            )
          };
    } else {
      mainButtonText = 'RSVP';
      onMainButtonPress = () {};
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
                    child: MyInlineButton(
                      color: neutralGrey,
                      text: 'Edit',
                      onTap: () {
                        showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          elevation: 0.0,
                          backgroundColor: Colors.white,
                          clipBehavior: Clip.antiAlias,
                          showDragHandle: true,
                          builder: (BuildContext context) => EventCreateModal(
                              exists: true,
                              initialSelectedPlace: PlaceAutoComplete(
                                'Harvard Square, Brattle Street, Cambridge, MA, USA',
                                'ChIJecplvEJ344kRdjumhjIYylk',
                              ), //pull this info from the backend...
                              initialCoords: const LatLng(42.3730, 71.1209)),
                        );
                      }, // This is where on edit function will go.
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
                  child: MyInlineButton(
                    color: isMember ? attendingOrange : absentRed,
                    text: mainButtonText,
                    onTap: onMainButtonPress,
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
