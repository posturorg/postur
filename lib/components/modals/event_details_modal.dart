import 'package:auth_test/components/dialogs/default_two_option_dialog.dart';
import 'package:auth_test/components/modals/event_create_modal.dart';
import 'package:auth_test/pages/attending_event_list.dart';
import 'package:auth_test/src/event_info_services.dart';
import 'package:auth_test/src/places/places_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import '../modal_bottom_button.dart';
import '../../src/event_box_decoration.dart';
import '../../src/colors.dart';

class EventDetailsModal extends StatefulWidget {
  final String eventId;
  final String eventTitle;
  final String creator;
  final bool? isCreator;
  final bool? isAttending;

  const EventDetailsModal({
    super.key,
    required this.eventId,
    required this.eventTitle,
    required this.creator,
    required this.isCreator,
    required this.isAttending,
  });

  @override
  State<EventDetailsModal> createState() => _EventDetailsModalState();
}

class _EventDetailsModalState extends State<EventDetailsModal> {
  final TextStyle defaultBold = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 15,
  );

  final TextStyle defaultBody = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 15,
  );

  String creatorName = '';
  String creatorProfilePic = '';
  String eventTitle = '';
  Timestamp whenTime = Timestamp.fromDate(DateTime.now());
  Timestamp endTime = Timestamp.fromDate(DateTime.now());
  Timestamp rsvpTime = Timestamp.fromDate(DateTime.now());
  GeoPoint where = const GeoPoint(42.373, -71.1209);
  String attending = '';
  String description = '';

  // Get Creator Name
  Future<void> _getCreatorName() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.creator)
          .get();
      if (snapshot.exists) {
        setState(() {
          creatorName =
              '${snapshot['name']['first']} ${snapshot['name']['last']}';
          creatorProfilePic = snapshot['profile_pic'];
        });
      }
    } catch (e) {
      print("Error getting event creator's name: $e");
    }
  }

  // Get Event Data Name
  Future<void> _getEventData() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Events')
          .doc(widget.eventId)
          .get();
      if (snapshot.exists) {
        setState(() {
          eventTitle = snapshot['eventTitle'];
          whenTime = snapshot['whenTime'];
          endTime = snapshot['endTime'];
          rsvpTime = snapshot['rsvpTime'];
          where = snapshot['where'];
          description = snapshot['description'];
        });
      }
    } catch (e) {
      print("Error getting event info: $e");
    }
  }

  // This function formats timestamps from the backend to be displayed
  String _formatTimestamp(Timestamp timestamp) {
    DateTime now = DateTime.now();
    DateTime eventTime = timestamp.toDate();

    int daysDifference = DateTime(now.year, now.month, now.day)
        .difference(DateTime(eventTime.year, eventTime.month, eventTime.day))
        .inDays;

    if (daysDifference == 0) {
      String formattedDate = DateFormat('hh:mm a').format(eventTime);
      return 'Today, $formattedDate';
    } else if (daysDifference == -1) {
      String formattedDate = DateFormat('hh:mm a').format(eventTime);
      return 'Tomorrow, $formattedDate';
    } else if (daysDifference == 1) {
      String formattedDate = DateFormat('hh:mm a').format(eventTime);
      return 'Yesterday, $formattedDate';
    } else if (1 < daysDifference && daysDifference <= 7) {
      String formattedDate = DateFormat('hh:mm a').format(eventTime);

      if (now.add(const Duration(days: 1)).weekday >
          eventTime.add(const Duration(days: 1)).weekday) {
        return 'This past ${_getWeekdayName(eventTime.weekday)}, $formattedDate';
      } else {
        return 'Last ${_getWeekdayName(eventTime.weekday)}, $formattedDate';
      }
    } else if (-7 < daysDifference && daysDifference < -1) {
      String formattedDate = DateFormat('hh:mm a').format(eventTime);

      if (now.add(const Duration(days: 1)).weekday >
          eventTime.add(const Duration(days: 1)).weekday) {
        return 'Next ${_getWeekdayName(eventTime.weekday)}, $formattedDate';
      } else {
        return 'This ${_getWeekdayName(eventTime.weekday)}, $formattedDate';
      }
    } else if (daysDifference == -7) {
      String formattedDate = DateFormat('hh:mm a').format(eventTime);
      return 'Next ${_getWeekdayName(eventTime.weekday)}, $formattedDate';
    } else {
      String formattedDate =
          DateFormat('EEE, MMM d, hh:mm a').format(eventTime);
      return formattedDate;
    }
  }

  String _getWeekdayName(int weekday) {
    List<String> weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return weekdays[weekday - 1];
  }

  Set<String> thoseInvited = {};

  Future<void> fetchThoseInvited() async {
    CollectionReference<Map<String, dynamic>> relevantCollection =
        FirebaseFirestore.instance
            .collection('Events')
            .doc(widget.eventId)
            .collection('Invited');
    Set<String> thoseInvitedInternal =
        await getUidsFromCollection(relevantCollection);
    setState(() {
      thoseInvited = thoseInvitedInternal;
    });
  }

  @override
  void initState() {
    super.initState();
    _getCreatorName();
    _getEventData();
    Future.delayed(Duration.zero, () {
      this.fetchThoseInvited();
    });
  }

  void cancelEvent() async {
    try {
      // Step 1: Delete Invited Users and MyEvents Documents
      final eventRef =
          FirebaseFirestore.instance.collection('Events').doc(widget.eventId);
      final invitedQuery = eventRef.collection('Invited');
      final invitedSnapshot = await invitedQuery.get();

      final batch = FirebaseFirestore.instance.batch();

      for (QueryDocumentSnapshot invitedDoc in invitedSnapshot.docs) {
        final userId = invitedDoc.id;
        final myEventsRef = FirebaseFirestore.instance
            .collection('EventMembers')
            .doc(userId)
            .collection('MyEvents')
            .doc(widget.eventId);

        batch.delete(
            myEventsRef); // Delete MyEvents document for each invited user
        batch.delete(invitedQuery.doc(
            userId)); // Delete document in the Invited subcollection corresponding to each invited user
      }

      // Step 2: Delete Event Document
      batch.delete(eventRef);

      // Commit the batch delete
      await batch.commit();
    } catch (e) {
      print("Error canceling event: $e");
    }
  }

  // Call this function when the "Cancel Event" button is pressed
  void onPressedCancelButton() {
    cancelEvent();
  }

  @override
  Widget build(BuildContext context) {
    late String bottomButtonText;
    late Function()? onMainBottomTap;
    if (widget.isCreator!) {
      bottomButtonText = 'Cancel';
      onMainBottomTap = () => {
            showCupertinoDialog(
              context: context,
              builder: (context) => DefaultTwoOptionDialog(
                title: 'Are you sure?',
                content: 'Are you sure you want to cancel this event?',
                optionOneText: 'Yes, poop the party.',
                optionTwoText: 'No, party on!',
                onOptionOne: () => {
                  // Delete relevant documents from backend
                  onPressedCancelButton(),

                  // Close alert
                  Navigator.pop(context),

                  // Close modal
                  Navigator.pop(context),
                }, //Should cancel event, and pop both modals
                onOptionTwo: () => Navigator.pop(context),
              ),
            )
          };
    } else if (widget.isAttending!) {
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
              widget.eventTitle,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: widget.isAttending! ? attendingOrange : absentRed,
              ),
            ),
            Container(
              decoration: eventBoxDecoration(),
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Creator: ${widget.isCreator! ? 'Me' : creatorName}',
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
                            text: _formatTimestamp(whenTime),
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
                            text: _formatTimestamp(endTime),
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
                            text: _formatTimestamp(rsvpTime),
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
                                            eventId: widget.eventId,
                                            isAttending: widget.isAttending!,
                                            namesAttending: const [
                                              {
                                                'name': 'Ben duPont',
                                                'userID': 'bjb8ou91bkj',
                                                'imageUrl':
                                                    'https://www.gradeinflation.com',
                                              },
                                              {
                                                'name': 'Alvin Adjei',
                                                'userID': 'iwhefujbc98392',
                                                'imageUrl':
                                                    'https://www.gradeinflation.com',
                                              },
                                              {
                                                'name': 'I go to yale12345',
                                                'userID': 'iwhefujbc98392',
                                                'imageUrl':
                                                    'https://www.gradeinflation.com',
                                              },
                                            ], //Get this from the backend!
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
                            text: description,
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
                      visible: widget.isCreator!,
                      child: ModalBottomButton(
                        onTap: () async {
                          //first close this existing modal.
                          Navigator.pop(
                              context); //first close this existing modal.
                          showModalBottomSheet<void>(
                            //then, open new one
                            context: context,
                            isScrollControlled: true,
                            elevation: 0.0,
                            backgroundColor: Colors.white,
                            clipBehavior: Clip.antiAlias,
                            showDragHandle: true,
                            builder: (BuildContext context) => EventCreateModal(
                              thoseInvited: thoseInvited,
                              exists: true, //also, toggles creator, Me
                              initialSelectedPlace: PlaceAutoComplete(
                                'Harvard Square, Brattle Street, Cambridge, MA, USA',
                                'ChIJecplvEJ344kRdjumhjIYylk',
                              ), //This info should be pulled from the backend
                              initialCoords: const LatLng(42.3730,
                                  71.1209), //Also should be obtained from the backend
                            ),
                          );
                        },
                        text: 'Edit',
                        backgroundColor: neutralGrey,
                      ),
                    ),
                    ModalBottomButton(
                      onTap: onMainBottomTap,
                      text: bottomButtonText,
                      backgroundColor:
                          widget.isAttending! ? attendingOrange : absentRed,
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
