import 'package:auth_test/components/dialogs/default_one_option_dialog.dart';
import 'package:auth_test/components/dialogs/default_two_option_dialog.dart';
import 'package:auth_test/components/modals/event_create_modal.dart';
import 'package:auth_test/components/my_inline_button.dart';
import 'package:auth_test/src/event_info_services.dart';
import 'package:auth_test/src/places/places_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'modals/event_details_modal.dart';
import '../src/colors.dart';

class MenuEventWidget extends StatefulWidget {
  final String eventId;
  final String eventCreator;
  final bool isCreator;
  final bool isAttending;

  const MenuEventWidget({
    super.key,
    required this.eventId,
    required this.eventCreator,
    required this.isCreator,
    required this.isAttending,
  });

  @override
  State<MenuEventWidget> createState() => _MenuEventWidgetState();
}

class _MenuEventWidgetState extends State<MenuEventWidget> {
  String fullName = '';
  String profilePic = '';

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

  Future<void> _getCreatorInfo() async {
    late DocumentSnapshot documentSnapshot;

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.eventCreator)
        .get()
        .then((value) {
      documentSnapshot = value;
    });

    if (documentSnapshot.exists) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      setState(() {
        fullName = '${data['name']['first']} ${data['name']['last']}';
        profilePic = data['profile_pic'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getCreatorInfo();
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
    late String mainButtonText;
    late Function()? onMainButtonPress;
    if (widget.isCreator) {
      mainButtonText = 'Cancel';
      onMainButtonPress = () => {
            showCupertinoDialog(
              //Need to compress this
              context: context,
              builder: (_) => DefaultTwoOptionDialog(
                title: 'Are you sure?',
                content: 'Are you sure you want to cancel the event?',
                optionOneText: 'Yes, poop the party.',
                optionTwoText: 'No, party on!',
                onOptionOne: () => {
                  // Delete relevant documents from backend
                  onPressedCancelButton(),

                  // Close alert
                  Navigator.pop(context),
                },
                onOptionTwo: () {
                  Navigator.pop(context);
                },
              ),
            )
          };
    } else if (widget.isAttending) {
      mainButtonText = 'Leave';
      onMainButtonPress = () => {
            showCupertinoDialog(
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

    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Events')
            .doc(widget.eventId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show Waiting Indicator
            return const Center(
                child: CircularProgressIndicator(
              color: absentRed,
            ));
            // What to show if data has been received
          } else if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            // Potenital error message
            if (snapshot.hasError) {
              return const Center(child: Text("Error Occured"));
              // Success
            } else if (snapshot.hasData) {
              String eventTitle = snapshot.data!['eventTitle'];
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
                        eventId: widget.eventId,
                        eventTitle: eventTitle,
                        creator: widget.eventCreator,
                        isCreator: widget.isCreator,
                        isAttending: widget.isAttending,
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
                              widget.isCreator ? 'Me' : fullName,
                              style: const TextStyle(
                                fontSize: 15,
                                color: neutralGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Visibility(
                              visible: widget.isCreator,
                              child: MyInlineButton(
                                color: neutralGrey,
                                text: 'Edit',
                                onTap: () async {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    attendingOrange),
                                          ),
                                        );
                                      });
                                  try {
                                    CollectionReference<Map<String, dynamic>>
                                        relevantCollection = FirebaseFirestore
                                            .instance
                                            .collection('Events')
                                            .doc(widget.eventId)
                                            .collection('Invited');

                                    DocumentSnapshot eventSnapshot =
                                        await FirebaseFirestore.instance
                                            .collection('Events')
                                            .doc(widget.eventId)
                                            .get();

                                    String initialTitle =
                                        eventSnapshot['eventTitle'];

                                    String initialDescription =
                                        eventSnapshot['description'];

                                    Map<String, dynamic> eventData =
                                        eventSnapshot.data()
                                            as Map<String, dynamic>;
                                    GeoPoint whereGeoPoint = eventData['where'];

                                    double initialLatitude =
                                        whereGeoPoint.latitude;

                                    double initialLongitude =
                                        whereGeoPoint.longitude;

                                    LatLng initialCoords = LatLng(
                                        initialLatitude, initialLongitude);

                                    PlaceAutoComplete initialSelectedPlace =
                                        await PlacesRepository()
                                            .getPlaceAutoCompleteFromLatLng(
                                                initialCoords);

                                    Set<String>
                                        thoseInvitedInternal = //need to fix this!
                                        await getUidsFromCollection(
                                            relevantCollection);
                                    Navigator.pop(
                                        context); //pops spinning wheel of death.

                                    // ignore: use_build_context_synchronously
                                    showModalBottomSheet<void>(
                                      context: context,
                                      isScrollControlled: true,
                                      elevation: 0.0,
                                      backgroundColor: Colors.white,
                                      clipBehavior: Clip.antiAlias,
                                      showDragHandle: true,
                                      builder: (BuildContext context) =>
                                          EventCreateModal(
                                              initialTitle: eventTitle,
                                              initialDescription:
                                                  initialDescription,
                                              eventID: widget.eventId,
                                              thoseInvited:
                                                  thoseInvitedInternal,
                                              exists: true,
                                              initialSelectedPlace:
                                                  initialSelectedPlace,
                                              initialCoords: initialCoords),
                                    );
                                  } catch (e) {
                                    Navigator.pop(context);
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          DefaultOneOptionDialog(
                                        title: e.toString(),
                                        buttonText: 'Ok',
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    );
                                  }
                                },
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
                              color: widget.isAttending
                                  ? attendingOrange
                                  : absentRed,
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
          return const Text("Don't worry, be happy :)");
        });
  }
}
