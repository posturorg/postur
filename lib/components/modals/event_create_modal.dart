import 'package:auth_test/components/create_event_datetime.dart';
import 'package:auth_test/components/event_address_form.dart';
import 'package:auth_test/components/modal_bottom_button.dart';
import '../event_box_decoration.dart';
import '../../src/colors.dart';
import 'package:flutter/material.dart';

/*
This widget is what appears inside the modal for event creation
 */

TextEditingController addressController = TextEditingController(
    //text: 'Massachusetts Hall, Cambridge, MA 02138',
    );

class EventCreateModal extends StatelessWidget {
  const EventCreateModal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
            // Ultimately, this needs to be converted into a textbox for users
            // To enter their event's title
            const Text(
              'eventTitle',
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
                  Text('Creator: Me',
                      style: TextStyle(
                        fontSize: 17,
                      )),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('When:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: SizedBox(
                        width: 200.0,
                        height: 50.0,
                        child: CreateEventDateTime()),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Ends:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: SizedBox(
                        width: 200.0,
                        height: 50.0,
                        child: CreateEventDateTime()),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('RSVP by:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: SizedBox(
                      width: 200.0,
                      height: 50.0,
                      child: CreateEventDateTime(),
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
                  const Text('Where:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: SizedBox(
                      width: 200.0,
                      height: 50.0,
                      child: EventAddressForm(
                        defaultText: 'Massachusetts Hall, Cambridg',
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
                        children: const [
                          TextSpan(
                            text: 'Attending: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          TextSpan(
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
                  const Text('Description:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
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
                        onTap: () {}, //This should create the pin and event
                        text: 'Create',
                        backgroundColor: attendingOrange)
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
