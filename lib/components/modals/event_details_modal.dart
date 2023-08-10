import 'package:auth_test/components/dialogs/default_two_option_dialog.dart';
import 'package:auth_test/components/modals/event_create_modal.dart';
import 'package:auth_test/pages/attending_event_list.dart';
import 'package:auth_test/src/places/places_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../modal_bottom_button.dart';
import '../event_box_decoration.dart';
import '../../src/colors.dart';

class EventDetailsModal extends StatelessWidget {
  final String eventTitle;
  final String eventCreator;
  final bool isCreator;
  final bool isMember;

  const EventDetailsModal({
    super.key,
    required this.eventTitle,
    required this.eventCreator,
    required this.isCreator,
    required this.isMember,
  });

  final TextStyle defaultBold = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 15,
  );

  final TextStyle defaultBody = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 15,
  );

  @override
  Widget build(BuildContext context) {
    late String bottomButtonText;
    late Function()? onMainBottomTap;
    if (isCreator) {
      bottomButtonText = 'Cancel';
      onMainBottomTap = () => {
            showCupertinoDialog(
              context: context,
              builder: (context) => DefaultTwoOptionDialog(
                title: 'Are you sure?',
                content: 'Are you sure you want to cancel this event?',
                optionOneText: 'Yes, poop the party.',
                optionTwoText: 'No, party on!',
                onOptionOne: () {}, //Should leave event, and pop both modals
                onOptionTwo: () => {Navigator.pop(context)},
              ),
            )
          };
    } else if (isMember) {
      bottomButtonText = 'Leave';
      onMainBottomTap = () => {
            showCupertinoDialog(
              context: context,
              builder: (context) => DefaultTwoOptionDialog(
                title: 'Are you sure?',
                content: 'Are you sure you want to leave this event?',
                optionOneText: 'Yes',
                optionTwoText: 'No',
                onOptionOne: () {}, //Should leave event, and pop both modals
                onOptionTwo: () => {Navigator.pop(context)},
              ),
            )
          };
    } else {
      bottomButtonText = 'RSVP';
      onMainBottomTap = () {};
    }
    return SizedBox(
      height: 670,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Icon(
              Icons.circle,
              size: 85,
            ),
            Text(
              eventTitle,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isMember ? attendingOrange : absentRed,
              ),
            ),
            Container(
              decoration: eventBoxDecoration(),
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Creator: ${isCreator ? 'Me' : eventCreator}',
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context)
                            .style, // Use the default text style from the context
                        children: [
                          TextSpan(
                            text: 'When: ',
                            style: defaultBold,
                          ),
                          TextSpan(
                            text: 'This Wednesday, 7:30 p.m.',
                            style: defaultBody,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context)
                            .style, // Use the default text style from the context
                        children: [
                          TextSpan(
                            text: 'Ends: ',
                            style: defaultBold,
                          ),
                          TextSpan(
                            text: '10 p.m.',
                            style: defaultBody,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context)
                            .style, // Use the default text style from the context
                        children: [
                          TextSpan(
                            text: 'RSVP by: ',
                            style: defaultBold,
                          ),
                          TextSpan(
                            text: 'This Tuesday, 10 a.m.',
                            style: defaultBody,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context)
                            .style, // Use the default text style from the context
                        children: [
                          TextSpan(
                            text: 'Where: ',
                            style: defaultBold,
                          ),
                          TextSpan(
                            text:
                                '901 Fictitious Square, Unreal City, USA 67890',
                            style: defaultBody,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context)
                            .style, // Use the default text style from the context
                        children: [
                          TextSpan(
                            text: 'Attending: ',
                            style: defaultBold,
                          ),
                          TextSpan(
                            text:
                                'Thomas Kowalski, William Gödeler, & 24 others...', //This shall be a function of who is actually attending.
                            style: defaultBody,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AttendingEventList(
                                            isAttending: isMember,
                                            namesAttending: [],
                                          ))),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context)
                            .style, // Use the default text style from the context
                        children: [
                          TextSpan(
                            text: 'Description: ',
                            style: defaultBold,
                          ),
                          TextSpan(
                            text:
                                'Never gonna give you up, never gonna let you down, never gonna run around and desert you!',
                            style: defaultBody,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Visibility(
                      visible: isCreator,
                      child: ModalBottomButton(
                        onTap: () => {
                          //first close this existing modal.
                          //then, open new one
                          Navigator.pop(context),
                          showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            elevation: 0.0,
                            backgroundColor: Colors.white,
                            clipBehavior: Clip.antiAlias,
                            showDragHandle: true,
                            builder: (BuildContext context) => EventCreateModal(
                              exists: true, //also, toggles creator, Me
                              initialSelectedPlace: PlaceAutoComplete(
                                'Harvard Square, Brattle Street, Cambridge, MA, USA',
                                'ChIJecplvEJ344kRdjumhjIYylk',
                              ), //This info should be pulled from the backend
                              initialCoords: const LatLng(42.3730,
                                  71.1209), //Also should be obtained from the backend
                            ),
                          )
                        },
                        text: 'Edit',
                        backgroundColor: neutralGrey,
                      ),
                    ),
                    ModalBottomButton(
                      onTap: onMainBottomTap,
                      text: bottomButtonText,
                      backgroundColor: isMember ? attendingOrange : absentRed,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
