import 'package:auth_test/components/create_event_datetime.dart';
import 'package:auth_test/components/dialogs/default_two_option_dialog.dart';
import 'package:auth_test/components/event_address_form.dart';
import 'package:auth_test/components/modal_bottom_button.dart';
import 'package:flutter/cupertino.dart';
import '../event_box_decoration.dart';
import '../../src/colors.dart';
import 'package:flutter/material.dart';

/*
This widget is what appears inside the modal for event creation
 */

class EventCreateModal extends StatefulWidget {
  final bool
      exists; //essentially toggles whether or not this is an editing widget...

  const EventCreateModal({
    super.key,
    required this.exists,
  });

  @override
  State<EventCreateModal> createState() => _EventCreateModalState();
}

class _EventCreateModalState extends State<EventCreateModal> {
  final TextEditingController addressSearchController = TextEditingController();
  final TextStyle defaultBold = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 15,
  );

  @override
  void dispose() {
    //might not really be necessary tbh
    addressSearchController.dispose();
    super.dispose(); //Might need to go back and check that this is implemented
    //more broadly, that way we dont get errors with controllers being filled
    //from prior instances when they shouldn't be.
  }

  @override
  Widget build(BuildContext context) {
    late Function()? onBottomButtonPress;
    PlaceAutoComplete selectedPlace = PlaceAutoComplete(
      '945 Memorial Dr, Cambridge, MA 02138, USA',
      'ChIJ-6iWRFx344kRuHaZREqdanQ',
    );
    if (widget.exists) {
      onBottomButtonPress = () => {
            showCupertinoDialog(
              context: context,
              builder: (context) => DefaultTwoOptionDialog(
                title: 'Confirm event changes?',
                optionOneText: 'Yes, confirm',
                onOptionOne: () {}, //interface with backend to change event...
                optionTwoText: 'No',
                onOptionTwo: () => {Navigator.pop(context)},
              ),
            )
          };
    } else {
      onBottomButtonPress = () => {}; //This should be where code for
      //event creation and pin placement go
    }

    void setSelectedPlace(PlaceAutoComplete place) {
      // This is part
      //of function that executes upon hitting the arrow of the
      //address autocomplete modal
      setState(() {
        selectedPlace = place;
      });
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
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
<<<<<<< HEAD
                        defaultPlace: selectedPlace,
=======
                        defaultText: 'Massachusetts Hall, Cambridge', //Should
                        //be the events address, as given by its coordinates,
                        //by default.
                        //controller: //This is a text editing controller to
                        //help with editing the address in the inner modal.
>>>>>>> parent of a884ce8 (Updated Autocomplete)
                        addressSearchController: addressSearchController,
                        selectedPlaceSetter: setSelectedPlace,
                      ),
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
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
