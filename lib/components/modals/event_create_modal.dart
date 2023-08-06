import 'package:auth_test/components/create_event_datetime.dart';
import 'package:auth_test/components/dialogs/default_one_option_dialog.dart';
import 'package:auth_test/components/dialogs/default_two_option_dialog.dart';
import 'package:auth_test/components/event_address_form.dart';
import 'package:auth_test/components/modal_bottom_button.dart';
import 'package:auth_test/src/places/places_repository.dart';
import 'package:flutter/cupertino.dart';
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

  const EventCreateModal({
    super.key,
    required this.exists,
    required this.initialSelectedPlace,
    required this.initialCoords, // will get this from where you click on the map
  });

  @override
  State<EventCreateModal> createState() => _EventCreateModalState();
}

class _EventCreateModalState extends State<EventCreateModal> {
  final TextEditingController addressSearchController = TextEditingController();
  late PlaceAutoComplete selectedPlace;
  late LatLng currentCoords;
  late bool changedAddress;
  final EdgeInsets centralEdgeInset = const EdgeInsets.fromLTRB(
      20, 10, 20, 0); // this controlls the spacing of the 'meat' the modal

  void setSelectedPlace(PlaceAutoComplete newPlace) {
    setState(() {
      selectedPlace = newPlace;
      changedAddress = true;
    });
  }

  @override
  void initState() {
    super.initState();
    selectedPlace = widget
        .initialSelectedPlace; // Initialize the variable from the parameter
    currentCoords = widget.initialCoords;
    changedAddress = false;
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
      height: 750,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Icon(
              Icons.circle,
              size: 85,
            ),
            const Text(
              'eventTitle', //Need to make this editable, as a text box...
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: attendingOrange,
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
                  const Expanded(
                    child: SizedBox(
                      width: 200.0,
                      height: 50.0,
                      child: CreateEventDateTime(
                        upperText: 'When:',
                      ),
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
                  const Expanded(
                    child: SizedBox(
                      width: 200.0,
                      height: 50.0,
                      child: CreateEventDateTime(
                        upperText: 'Ends:',
                      ),
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
                  const Expanded(
                    child: SizedBox(
                      width: 200.0,
                      height: 50.0,
                      child: CreateEventDateTime(
                        upperText: 'RSVP by:',
                      ),
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
                    child: SizedBox(
                      width: 200.0,
                      height: 50.0,
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
                  ),
                ],
              ),
            ),
            Container(
              margin: centralEdgeInset,
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
                            text: 'Invite: ',
                            style: defaultBold,
                          ),
                          const TextSpan(
                            text: 'Thomas Kowalski, William Gödeler',
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: centralEdgeInset,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Description:',
                    style: defaultBold,
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: SizedBox(
                      width: 200.0,
                      height: 50.0,
                      child: TextFormField(
                        decoration: const InputDecoration(
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
