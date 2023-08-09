import 'package:auth_test/components/create_event_datetime.dart';
import 'package:auth_test/components/dialogs/default_one_option_dialog.dart';
import 'package:auth_test/components/dialogs/default_two_option_dialog.dart';
import 'package:auth_test/components/event_address_form.dart';
import 'package:auth_test/components/modal_bottom_button.dart';
import 'package:auth_test/pages/attending_event_list.dart';
import 'package:auth_test/src/places/places_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/route_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../event_box_decoration.dart';
import '../../src/colors.dart';
import 'package:flutter/material.dart';

/*
This widget is what appears inside the modal for event creation
 */

class EventCreateModal extends StatefulWidget {
  final bool
      exists; //essentially toggles whether or not this is an editing widget...
  final PlaceAutoComplete initialSelectedPlace;
  final LatLng initialCoords;
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
    DateTime whenTime = DateTime.now();
    DateTime endTime = DateTime.now();
    DateTime rsvpTime = DateTime.now();
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
      onBottomButtonPress = () => {}; //This should be where code for
      //event creation and pin placement go
    }
    return SizedBox(
      height: 775, // make this by default a function on whether or not you are
      // "focused" on the description editing box. Should be 700 when not and 775
      // when it is...
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
                    const SizedBox(width: 8.0),
                    const Text('Function of Number of Peeps invited!'),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AttendingEventList()),
                );
              },
              icon: const Icon(Icons.plus_one),
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
