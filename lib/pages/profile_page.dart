//import 'package:flutter/cupertino.dart';
import 'package:auth_test/src/widgets.dart';
import 'package:flutter/material.dart';
import '../src/colors.dart';
import '../components/id_widget.dart';
import 'qr_scan_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  BoxDecoration tagBoxDecoration() {
    return const BoxDecoration(
      border: Border(
          bottom: BorderSide(
        color: backgroundWhite,
        width: 1.0,
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget profileButtons = Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QRScanPage()));
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                backgroundColor: absentRed,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 0.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Scan',
                      style: TextStyle(
                        color: Colors.white,
                      )),
                  Container(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              backgroundColor: const Color.fromARGB(255, 93, 93, 93),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 0.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Edit',
                    style: TextStyle(
                      color: Colors.white,
                    )),
                Container(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: const Icon(Icons.edit_outlined, color: Colors.white),
                ),
              ],
            ),
            onPressed: () {
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
                  return SizedBox(
                    height: 750,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            decoration: tagBoxDecoration(),
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: 85,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text('Name:',
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
                                        hintText: 'Alvin Adjei',
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
                          Container(
                            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text('Username:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    )),
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: SizedBox(
                                    width: 200.0,
                                    height: 50.0,
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        hintText: 'alldayadjei',
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
                          Container(
                            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text('Password:',
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
                                        hintText: 'Password',
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
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 20),
                                      backgroundColor:
                                          const Color.fromARGB(255, 95, 95, 95),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(13)),
                                      elevation: 0.0,
                                    ),
                                    child: const Text('Cancel',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        )),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 14),
                                      backgroundColor: absentRed,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(13)),
                                      elevation: 0.0,
                                    ),
                                    child: const Text('Confirm',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );

    BoxDecoration sectionBoxDecoration() {
      return const BoxDecoration(
        border: Border(
            top: BorderSide(
          color: backgroundWhite,
          width: 1.0,
        )),
      );
    }

    Widget yourEvents = Container(
        decoration: sectionBoxDecoration(),
        padding: const EdgeInsets.fromLTRB(20, 10, 25, 0),
        child: const Row(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Attending:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: attendingOrange,
                    )),
              ],
            ),
          ),
        ]));

    Widget inviteTitle = Container(
        decoration: sectionBoxDecoration(),
        padding: const EdgeInsets.fromLTRB(20, 10, 25, 0),
        child: const Row(children: [
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Invites:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: absentRed,
                  )),
            ]),
          ),
        ]));

    return ListView(children: [
      Column(children: [
        //qrCode,
        IDWidget(
          fullName: 'Alvin Adjei',
          userName: 'alldayadjei',
        ),
        profileButtons,
        yourEvents,
        YourEventWidget(
          eventTitle: 'Taco Tuesday',
          eventCreator: 'HUDS',
        ),
        AttendingEventsWidget(
          eventTitle: "Pete's Bday Party",
          eventCreator: '@petedagoat',
        ),
        inviteTitle,
        InviteEventWidget(
          inviteTitle: 'Booze Cruise',
          inviteCreator: 'Sigma Chi',
        ),
        InviteTagWidget(inviteTitle: 'Yale2024', inviteCreator: '@YaleAdmins'),
      ]),
    ]);
  }
}
