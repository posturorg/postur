import 'package:auth_test/components/dialogs/default_two_option_dialog.dart';
import 'package:auth_test/components/modals/event_create_modal.dart';
import 'package:auth_test/pages/attending_event_list.dart';
import 'package:auth_test/src/event_info_services.dart';
import 'package:auth_test/src/places/places_repository.dart';
import 'package:auth_test/src/user_info_services.dart';
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
  //TODO: CHECK WITH ALVIN ABOUT HOW THIS IS HANDLED. ENSURE THAT ANY USER IS
  //NOT BY DEFAULT THE EVENT CREATOR PRIOR TO LOADING.
  final bool? isCreator;
  final bool? isAttending;
  final void Function()? reloader;

  const EventDetailsModal({
    super.key,
    required this.eventId,
    required this.eventTitle,
    required this.creator,
    required this.isCreator,
    required this.isAttending,
    this.reloader,
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
  LatLng whereLatLng = const LatLng(42.373, -71.1209);
  //TODO: GOTTA ADD ACTUAL INFORMATION UPDATING
  PlaceAutoComplete wherePlaceInfo = PlaceAutoComplete(
    'Harvard Square, Brattle Street, Cambridge, MA, USA',
    'ChIJH9cEblR344kR4_5hOythj0k',
  );
  String attending = '';
  String description = '';
  bool hasFullyLoaded = false; //prevents small editing bug

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
      GeoPoint whereInternal = snapshot['where'];
      LatLng whereLatLngInternal =
          LatLng(whereInternal.latitude, whereInternal.longitude);
      PlaceAutoComplete wherePlaceInfoInternal = await PlacesRepository()
          .getPlaceAutoCompleteFromLatLng(whereLatLngInternal);
      if (snapshot.exists) {
        setState(() {
          eventTitle = snapshot['eventTitle'];
          whenTime = snapshot['whenTime'];
          endTime = snapshot['endTime'];
          rsvpTime = snapshot['rsvpTime'];
          where = whereInternal;
          whereLatLng = whereLatLngInternal;
          description = snapshot['description'];
          wherePlaceInfo = wherePlaceInfoInternal;
          hasFullyLoaded = true;
        });
      }
    } catch (e) {
      print("Error getting event info: ${e.toString()}");
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
  Set<String> tagsInvited = {};

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

  Future<void> fetchTagsInvited() async {
    CollectionReference<Map<String, dynamic>> relevantCollection =
        FirebaseFirestore.instance
            .collection('Events')
            .doc(widget.eventId)
            .collection('InvitedTags');
    Set<String> tagsInvitedInternal =
        await getTagIdsFromCollection(relevantCollection);
    setState(() {
      tagsInvited = tagsInvitedInternal;
    });
  }

  late Future<String> profilePicUrl;
  bool wasErrorLoadingPic = false;

  final Widget defaultAvatar = const CircleAvatar(
    backgroundImage: AssetImage('lib/assets/thumbtack.png'),
    radius: 37,
  );

  @override
  void initState() {
    super.initState();
    _getCreatorName();
    _getEventData();
    profilePicUrl = getProfilePicUrl(widget.creator, () {
      setState(() {
        wasErrorLoadingPic = true;
      });
    });
    Future.delayed(Duration.zero, () {
      fetchThoseInvited();
      fetchTagsInvited();
    });
  }

  // Call this function when the "Cancel Event" button is pressed
  void onPressedCancelButton() {
    if (hasFullyLoaded) {
      cancelEvent(widget.eventId);
      try {
        widget.reloader!();
      } catch (e) {
        print('No reloader for details modal!');
      }
    }
  }

  // Call this function when the "Leave" button is pressed
  void onPressedLeaveButton() {
    if (hasFullyLoaded) {
      leaveEvent(widget.eventId);
      try {
        widget.reloader!();
      } catch (e) {
        print('No reloader for details modal!');
      }
    }
  }

  void onPressedRSVPButton() {
    if (hasFullyLoaded) {
      rsvpToEvent(widget.eventId);
      try {
        widget.reloader!();
      } catch (e) {
        print('No reloader for details modal!');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    late String bottomButtonText; // move all of this out of build
    late Function()? onMainBottomTap;
    if (widget.isCreator!) {
      bottomButtonText = 'Cancel';
      onMainBottomTap = !hasFullyLoaded
          ? () {}
          : () => {
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
      onMainBottomTap = !hasFullyLoaded
          ? () {}
          : () => {
                showCupertinoDialog(
                  context: context,
                  builder: (context) => DefaultTwoOptionDialog(
                    title: 'Are you sure?',
                    content: 'Are you sure you want to leave this event?',
                    optionOneText: 'Yes',
                    optionTwoText: 'No',
                    onOptionOne: () => {
                      // Delete relevant documents from backend
                      onPressedLeaveButton(),
                      // Close alert
                      Navigator.pop(context),
                      // Close modal
                      Navigator.pop(context),
                    }, //Should leave event, and pop both modals
                    onOptionTwo: () => {Navigator.pop(context)},
                  ),
                )
              };
    } else {
      bottomButtonText = 'RSVP';
      onMainBottomTap = !hasFullyLoaded
          ? () {}
          : () {
              // Update relevant documents from backend
              onPressedRSVPButton();
              // Close modal
              Navigator.pop(context);
            };
    }
    return SizedBox(
      height: 670,
      child: Center(
        child: !hasFullyLoaded
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(absentRed),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  FutureBuilder(
                    //you can probably make this more consise
                    future: profilePicUrl,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        print('snapshot had error!');
                        return defaultAvatar;
                      }
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (wasErrorLoadingPic) {
                          return defaultAvatar;
                        } else {
                          return CircleAvatar(
                            backgroundImage: NetworkImage(snapshot.data!),
                            radius: 37,
                          );
                        }
                      } else {
                        return defaultAvatar;
                      }
                    },
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
                                  text: wherePlaceInfo.address,
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
                                            builder: (context) =>
                                                AttendingEventList(
                                                  eventId: widget.eventId,
                                                  isAttending:
                                                      widget.isAttending!,
                                                  namesAttending: const [
                                                    {
                                                      'name': 'Ben duPont',
                                                      'userID': 'bjb8ou91bkj',
                                                      'imageUrl':
                                                          'https://www.gradeinflation.com',
                                                    },
                                                    {
                                                      'name': 'Alvin Adjei',
                                                      'userID':
                                                          'iwhefujbc98392',
                                                      'imageUrl':
                                                          'https://www.gradeinflation.com',
                                                    },
                                                    {
                                                      'name':
                                                          'I go to yale12345',
                                                      'userID':
                                                          'iwhefujbc98392',
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
                              onTap: !hasFullyLoaded
                                  ? () async {}
                                  : () async {
                                      //first close this existing modal.
                                      Navigator.pop(context);
                                      showModalBottomSheet<void>(
                                        //then, open new one
                                        context: context,
                                        isScrollControlled: true,
                                        elevation: 0.0,
                                        backgroundColor: Colors.white,
                                        clipBehavior: Clip.antiAlias,
                                        showDragHandle: true,
                                        builder: (context) => EventCreateModal(
                                          tagsInvited: tagsInvited, //should be pulled from backend
                                          reloader: widget.reloader,
                                          eventID: widget.eventId,
                                          initialTitle: eventTitle,
                                          initialDescription: description,
                                          initialCoords: whereLatLng,
                                          thoseInvited: thoseInvited,
                                          exists:
                                              true, //also, toggles creator, Me
                                          initialSelectedPlace: wherePlaceInfo,
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
                            backgroundColor: widget.isAttending!
                                ? attendingOrange
                                : absentRed,
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
