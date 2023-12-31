import 'dart:async';

import 'package:auth_test/pages/requests_page.dart';
import 'package:auth_test/src/user_info_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './dialogs/default_two_option_dialog.dart';
import '../components/tag_box_decoration.dart';
import '.././src/colors.dart';
import 'my_inline_button.dart';
import 'modals/tag_modal.dart';

/* isMember is a bool that toggles the COLOR of the widget between the orange
typically used for attendance (if its true), and red used for inattendance (if
its false). 

isCreator is a bool that determines whether or not the
requests button is shown at the bottom of the popup widget; this will only be
true for events you create.

Mapping (to ameliorate future understanding):

1.) isMember == false, isCreator == false, -> Tag that you are NOT
affiliated with.

2.) isMember == false, isCreator == true -> This will never naturally
happen, and is a remnant of us not having access to a "ternary" bool.

3.) isMember == true, isCreator == false -> Tag you are a member of,
but are not the creator of.

4.) isMember == true, isCreator == true -> Tag you created.
*/

//TODO: EVERY TIME ONE OF THESE LOADS, A QUERY IS MADE. LET'S FIND A MORE EFFICIENT WAY TO DO THIS!

class TagWidget extends StatefulWidget {
  final String tagId;
  final String tagCreator;
  final bool isMember;
  final bool isCreator;

  const TagWidget({
    super.key,
    required this.tagId,
    required this.tagCreator,
    required this.isMember,
    required this.isCreator,
  });

  @override
  State<TagWidget> createState() => _TagWidgetState();
}

class _TagWidgetState extends State<TagWidget> {
  /* Build out the widget */

  late Future<Map<String, String>> name;

  Future<Map<String, String>> getNameFromDocumentReference() async {
    try {
      // Get the document snapshot from the document reference
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.tagCreator)
          .get();

      // Check if the document exists
      if (documentSnapshot.exists) {
        // Extract the 'name' attribute from the document data
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        final String first = data['name']['first'];
        final String last = data['name']['last'];
        Map<String, String> name = {'first': first, 'last': last};

        // Return the 'name' attribute as a Future<String?>
        return name;
      } else {
        // Document does not exist
        return {'first': 'Error', 'last': 'fetching name...'};
      }
    } catch (e) {
      // Handle errors here
      print('error in fetching function!!!');
      print("Error: $e");
      return {'first': 'Error', 'last': 'fetching name...'};
    }
  }

  @override
  void initState() {
    name = getNameFromDocumentReference();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void onLeave() {
      showDialog(
        context: context,
        builder: (_) => DefaultTwoOptionDialog(
          title: 'Are you Sure?',
          content: 'Do you really want to leave #${widget.tagId}?',
          optionOneText: 'Yes, leave',
          optionTwoText: "No, don't leave",
          onOptionOne: () {},
          onOptionTwo: () => Navigator.pop(context),
        ),
        barrierDismissible: true,
      );
    }

    void onJoin() {}

    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Tags')
            .doc(widget.tagId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show Waiting Indicator
            return const Center(
              child: CircularProgressIndicator(
                color: absentRed,
              ),
            );
            // What to show if data has been received
          } else if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            // Potenital error message
            if (snapshot.hasError) {
              return const Center(child: Text("Error Occured"));
              // Success
            } else if (snapshot.hasData) {
              if (snapshot.data!.exists) {
                String tagTitle =
                    snapshot.data!['tagTitle']; // Retrieve tag title

                return GestureDetector(
                  // Wraps the entire widget in a butoon
                  //MODAL BEGIN
                  onTap: () {
                    // Function producing the draggable modal
                    //print("#$tagTitle details");
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
                        return TagModal(
                          tagId: widget.tagId,
                          tagTitle: tagTitle,
                          isCreator: widget.isCreator,
                          tagCreator: widget.tagCreator,
                          isMember: widget.isMember,
                        );
                      },
                    );
                  },
                  //MODAL STOP
                  child: Container(
                    // Build tag Widget
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
                              Text(
                                '#$tagTitle',
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Visibility(
                                visible: widget.isCreator,
                                child: const Text(
                                  'Me',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color:
                                        neutralGrey, //Maybe add this color to the colors file
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: !widget.isCreator,
                                child: FutureBuilder(
                                  future: name,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      // While the future is still loading, return a Text widget with "loading"
                                      return const Text(
                                        'Loading',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: neutralGrey,
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      print(snapshot.error.toString());
                                      return const Text(
                                          'Error fetching name...',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: neutralGrey));
                                    } else if (snapshot.hasData) {
                                      final nameData = snapshot.data!;
                                      final first = nameData['first'] ?? '';
                                      final last = nameData['last'] ?? '';
                                      final fullName = '$first $last';
                                      return Text(
                                        fullName,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: neutralGrey,
                                        ),
                                      );
                                    } else {
                                      return const Text(
                                        'No data...',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: neutralGrey,
                                        ),
                                      );
                                    }
                                  },
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
                                  text: 'Requests',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RequestsPage(
                                            tagId: widget.tagId,
                                            tagTitle:
                                                tagTitle), // TODO: Examine requests page
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        //Leave button:
                        Container(
                          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                          child: MyInlineButton(
                            text: widget.isCreator
                                ? 'Disband'
                                : widget.isMember
                                    ? 'Leave'
                                    : 'Join',
                            color:
                                widget.isMember ? attendingOrange : absentRed,
                            //NEED TO REPLACE ONTAP WITH A TERNARY WITH ONE FOR JOINING AND
                            //ONE FOR LEAVING
                            onTap: widget.isCreator
                                ? () {
                                    // Disband tag
                                    showCupertinoDialog(
                                      context: context,
                                      builder: (context) =>
                                          DefaultTwoOptionDialog(
                                        title: 'Are you sure?',
                                        content:
                                            'Are you sure you want to disband this tag?',
                                        optionOneText: 'Yes',
                                        optionTwoText: 'No',
                                        onOptionOne: () => {
                                          // Delete relevant documents from backend
                                          disbandTag(widget.tagId),
                                          // Close alert
                                          Navigator.pop(context),
                                        },
                                        onOptionTwo: () =>
                                            Navigator.pop(context),
                                      ),
                                    );
                                  }
                                : widget.isMember
                                    ? () {
                                        // Leave tag
                                        showCupertinoDialog(
                                          context: context,
                                          builder: (context) =>
                                              DefaultTwoOptionDialog(
                                            title: 'Are you sure?',
                                            content:
                                                'Are you sure you want to leave this tag?',
                                            optionOneText: 'Yes',
                                            optionTwoText: 'No',
                                            onOptionOne: () => {
                                              // Delete relevant documents from backend
                                              leaveTag(widget.tagId),
                                              // Close alert
                                              Navigator.pop(context),
                                            },
                                            onOptionTwo: () =>
                                                Navigator.pop(context),
                                          ),
                                        );
                                      }
                                    : () {
                                        // Join tag
                                        joinTag(widget.tagId);
                                      },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }
          }
          return const Text("Don't worry, be happy :)");
        });
  }
}
