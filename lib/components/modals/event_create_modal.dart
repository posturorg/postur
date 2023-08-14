// ignore_for_file: use_build_context_synchronously

import 'package:auth_test/components/create_event_datetime.dart';
import 'package:auth_test/components/dialogs/default_one_option_dialog.dart';
import 'package:auth_test/components/dialogs/default_two_option_dialog.dart';
import 'package:auth_test/components/event_address_form.dart';
import 'package:auth_test/components/modal_bottom_button.dart';
import 'package:auth_test/pages/invite_to_event_page.dart';
import 'package:auth_test/src/places/places_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../src/event_box_decoration.dart';
import '../../src/colors.dart';
import 'package:flutter/material.dart';

/*
This widget is what appears inside the modal for event creation
 */

class EventCreateModal extends StatefulWidget {
  final bool
      exists; //essentially toggles whether or not this is an editing widget...
  final PlaceAutoComplete initialSelectedPlace;
  final LatLng initialCoords; //will get this when you click on the map, or from
  //back end when editing an event
  final String? initialTitle;
  final String? initialDescription;

  const EventCreateModal({
    super.key,
    required this.exists,
    required this.initialSelectedPlace,
    required this.initialCoords, // will get this from where you click
    //on the map
    this.initialTitle,
    this.initialDescription,
  });

  @override
  State<EventCreateModal> createState() => _EventCreateModalState();
}

class _EventCreateModalState extends State<EventCreateModal> {
  late DateTime whenTime;
  late DateTime endTime;
  late DateTime rsvpTime;

  void changeWhen(DateTime newTime) {
    setState(() {
      whenTime = newTime;
    });
    print('WHEN: $whenTime');
  }

  void changeEnd(DateTime newTime) {
    setState(() {
      endTime = newTime;
    });
    print('END: $endTime');
  }

  void changeRsvp(DateTime newTime) {
    setState(() {
      rsvpTime = newTime;
    });
    print('RSVP: $rsvpTime');
  }

  final TextEditingController addressSearchController = TextEditingController();
  final TextEditingController eventTitleController = TextEditingController();
  final TextEditingController eventDescriptionController =
      TextEditingController();

  late PlaceAutoComplete selectedPlace;
  late LatLng currentCoords;
  late bool changedAddress;

  final EdgeInsets centralEdgeInset = const EdgeInsets.fromLTRB(
      20, 0, 20, 0); // this controlls the spacing of the 'meat' the modal

  void setSelectedPlace(PlaceAutoComplete newPlace) {
    setState(() {
      selectedPlace = newPlace;
      changedAddress = true;
    });
  }

  @override
  void initState() {
    super.initState();
    whenTime = DateTime.now();
    endTime = DateTime.now();
    rsvpTime = DateTime.now();
    selectedPlace = widget
        .initialSelectedPlace; // Initialize the variable from the parameter
    currentCoords = widget.initialCoords;
    changedAddress = false;
    if (widget.exists && widget.initialTitle != null) {
      eventTitleController.text = widget.initialTitle!;
    }
    if (widget.exists && widget.initialDescription != null) {
      eventDescriptionController.text = widget.initialDescription!;
    }
  }

  @override
  void dispose() {
    //might not really be necessary tbh
    addressSearchController.dispose();
    super.dispose(); //Might need to go back and check that this is implemented
    //more broadly, that way we dont get errors with controllers being filled
    //from prior instances when they shouldn't be.
  }

  final TextStyle defaultBold = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 15,
  );

  // Retrieve current user ID
  String uid = FirebaseAuth.instance.currentUser!.uid;

  // Retrieve current user document
  DocumentReference<Map<String, dynamic>> currentUser = FirebaseFirestore
      .instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  // Retrieve events data in order to update it in Firestore
  CollectionReference events = FirebaseFirestore.instance.collection('Events');

  Future<void> createEvent() async {
    // Create a new document reference with an auto-generated ID
    DocumentReference newEventRef = events.doc();

    // Get the auto-generated ID as a string
    String eventId = newEventRef.id;

    // Convert currentCoords to geopoint
    GeoPoint geoPoint =
        GeoPoint(currentCoords.latitude, currentCoords.longitude);

    // Retrieve creator's profile picture
    DocumentSnapshot documentSnapshot = await currentUser.get();
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    String profilePic = data['profile_pic'];

    Map<String, dynamic> eventDetails = {
      'creator': uid,
      'profile_pic': profilePic,
      'eventId': eventId,
      'eventTitle': eventTitleController.text,
      'whenTime': whenTime,
      'endTime': endTime,
      'rsvpTime': rsvpTime,
      'where': geoPoint,
      'description': eventDescriptionController.text,
      'isPrivate': true,
    };
    // currentUser.update({
    //   'invited': FieldValue.arrayUnion([eventId]),
    //   'attending': FieldValue.arrayUnion([eventId]),
    // });
    
    // Add event to current user's "MyEvents" subcollection in "EventMembers"
    Map<String, dynamic> eventMemberDetails = {
      'creator': uid,
      'eventId': eventId,
      'eventTitle': eventTitleController.text,
      'isCreator': true,
      'isAttending': true,
    };


    Map<String, dynamic> attendingList = {
      'uid': uid,
    };

    // Create new document in "MyEvents" subcollection with eventId
    DocumentReference newMyEventRef = FirebaseFirestore.instance
        .collection('EventMembers')
        .doc(uid)
        .collection('MyEvents')
        .doc(eventId);

    // Create new document in "Attending" subcollection with eventId
    DocumentReference newAttendingRef = FirebaseFirestore.instance.collection('Events').doc(eventId).collection('Attending').doc(uid);

    // Create "Events" doc using "set" function
    await newEventRef.set(eventDetails);
    // Create "MyEvents" doc using "set" function
    await newMyEventRef.set(eventMemberDetails);
    print('Event added with ID: ${newEventRef.id}');
  }

  @override
  Widget build(BuildContext context) {
    late Function()? onBottomButtonPress;
    if (widget.exists) {
      onBottomButtonPress = () => {
            showCupertinoDialog(
              context: context,
              builder: (context) => DefaultTwoOptionDialog(
                title: 'Confirm event changes?',
                optionOneText: 'Yes, confirm',
                onOptionOne: () async {
                  //does this need to be async
                  if (changedAddress) {
                    dynamic newCoords = await PlacesRepository()
                        .getCoordsFromPlaceId(selectedPlace.placeId);
                    //print(selectedPlace.placeId);
                    if (newCoords == null) {
                      Navigator.pop(
                          context); // this is a bad practice, apparently.
                      showCupertinoDialog(
                        context: context,
                        builder: (context) => DefaultOneOptionDialog(
                          title:
                              'Something went wrong. Check your internet connection or restart the app.',
                          buttonText: 'Ok',
                          onPressed: () => {Navigator.pop(context)},
                        ),
                      );
                    } else {
                      setState(() {
                        currentCoords = newCoords;
                        //print('-------NEW COORDS ARE:-------');
                        //print('${currentCoords.latitude}, ${currentCoords.longitude}');
                      });
                      Navigator.pop(context); //should close our popup
                      // this is where normally we would submit changed to the backend
                      Navigator.pop(context); //should close our modal

                      //HERE IS WHERE WE SHALL ADD THE CODE TO CREATE AN EVENT IN THE BACKEND.
                    }
                  } else {
                    //this is where we would normally submit changes to the backend
                    Navigator.pop(context); //Closes popup
                    Navigator.pop(context); //Closes modal
                  }
                }, //interface with backend to change event...
                optionTwoText: 'No',
                onOptionTwo: () => {Navigator.pop(context)},
              ),
            )
          };
    } else {
      onBottomButtonPress = () => {
            // Create event in the backend
            print('User created an event'),
            createEvent(),
            Navigator.pop(context), //Closes modal
          }; //This should be where code for
      //event creation and pin placement go
    }
    return SizedBox(
      height: 745, //Make this some fraction of the size of the safe area
      // also make this by default a function on whether or not you are
      // "focused" on the description editing box. Should be shorter when not
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 1),
              child: TextField(
                controller: eventTitleController,
                keyboardType: TextInputType.streetAddress,
                buildCounter: (BuildContext context,
                        {int? currentLength,
                        int? maxLength,
                        bool? isFocused}) =>
                    null,
                cursorColor: attendingOrange,
                maxLength: 20,
                maxLines: 1,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Event title...',
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: attendingOrange),
              ),
            ),
            Container(
              decoration: eventBoxDecoration(),
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Creator: Me',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: centralEdgeInset,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'When:',
                    style: defaultBold,
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: CreateEventDateTime(
                      upperText: 'When:',
                      onChange: changeWhen,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: centralEdgeInset,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Ends:',
                    style: defaultBold,
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: CreateEventDateTime(
                      upperText: 'Ends:',
                      onChange: changeEnd,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: centralEdgeInset,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'RSVP by:',
                    style: defaultBold,
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: CreateEventDateTime(
                      upperText: 'RSVP by:',
                      onChange: changeRsvp,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: centralEdgeInset,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Where:',
                    style: defaultBold,
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: EventAddressForm(
                      defaultPlace: selectedPlace, //Should
                      //be the events address, as given by its coordinates,
                      //by default.
                      //controller: //This is a text editing controller to
                      //help with editing the address in the inner modal.
                      addressSearchController: addressSearchController,
                      setExternalSelectedPlace: setSelectedPlace,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: centralEdgeInset,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    0, 0, 0, 0), // Padding is here in case you need to use it
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Description:',
                      style: defaultBold,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 3, 20, 0),
              child: Container(
                decoration: const BoxDecoration(
                  color: backgroundWhite,
                  borderRadius: BorderRadiusDirectional.all(
                    Radius.circular(7),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: TextField(
                    keyboardType: TextInputType.streetAddress, // This might be
                    // "fudging it." Check down the line to see it isn't causing
                    // any weirdness
                    minLines: 2,
                    maxLines: 2,
                    cursorColor: inputGrey,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter event details...',
                      isCollapsed: true,
                    ),
                    maxLength: 130,
                    controller: eventDescriptionController,
                    style: const TextStyle(
                      color: neutralGrey,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: centralEdgeInset,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Row(
                  //wont be constant, but whatever.
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Invite:',
                      style: defaultBold,
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const InviteToEventPage();
                            },
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.add,
                        color: attendingOrange,
                        size: 30,
                      ),
                    ),
                    const Text('#DunsterHaus, Alvin Adjei, & 20 others'),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ModalBottomButton(
                      onTap: onBottomButtonPress,
                      text: widget.exists ? 'Confirm Changes' : 'Create',
                      backgroundColor: attendingOrange,
                    )
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
