import 'package:auth_test/components/dialogs/default_two_option_dialog.dart';
import 'package:auth_test/components/modal_bottom_button.dart';
import 'package:auth_test/src/event_info_services.dart';
import 'package:auth_test/src/user_info_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../src/colors.dart';
import '../tag_box_decoration.dart';
import 'package:flutter/material.dart';

import 'create_tag_modal.dart';

class TagModal extends StatefulWidget {
  final String tagId;
  final String tagTitle;
  final bool isCreator;
  final String tagCreator;
  final bool isMember;

  const TagModal({
    super.key,
    required this.tagId,
    required this.tagTitle,
    required this.isCreator,
    required this.tagCreator,
    required this.isMember,
  });

  @override
  State<TagModal> createState() => _TagModalState();
}

class _TagModalState extends State<TagModal> {
  // Initialize description string
  String description = '';

  // Initialize set of people invited to tag
  Set<String> thoseInvited = {};

  // Function that fetches invite list
  Future<void> fetchThoseInvited() async {
    CollectionReference<Map<String, dynamic>> relevantCollection =
        FirebaseFirestore.instance
            .collection('Tags')
            .doc(widget.tagId)
            .collection('Members');
    Set<String> thoseInvitedInternal =
        await getUidsFromCollection(relevantCollection);
    setState(() {
      thoseInvited = thoseInvitedInternal;
    });
  }


  // Get Event Data Name
  Future<void> _getTagData() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Tags')
          .doc(widget.tagId)
          .get();
      if (snapshot.exists) {
        setState(() {
          description = snapshot['description'];
        });
      }
    } catch (e) {
      print("Error getting event info: ${e.toString()}");
    }
  }

  @override
  void initState() {
    super.initState();
    _getTagData();
    Future.delayed(Duration.zero, () {
      this.fetchThoseInvited();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 700,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Icon(
              Icons.circle,
              size: 85,
            ),
            Text(
              '#${widget.tagTitle}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: widget.isMember ? attendingOrange : absentRed,
              ),
            ),
            Container(
              decoration: tagBoxDecoration(),
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Creator: ${widget.isCreator ? 'Me' : widget.tagCreator}',
                      style: const TextStyle(
                        fontSize: 17,
                      )),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context)
                            .style, // Use the default text style from the context
                        children: [
                          const TextSpan(
                            text: 'Description: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          TextSpan(
                            text:
                                description,
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
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
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
                            text: 'Members: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          TextSpan(
                            text:
                                'Never gonna make you cry, never gonna say goodbye, never gonna tell a lie and hurt you!',
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
            Expanded(
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Visibility(
                        visible: widget.isCreator,
                        //This is the edit button:
                        child: ModalBottomButton(
                          onTap: () async {
                            Navigator.pop(context);
                            showModalBottomSheet<void>(
                            //then, open new one
                            context: context,
                            isScrollControlled: true,
                            elevation: 0.0,
                            backgroundColor: Colors.white,
                            clipBehavior: Clip.antiAlias,
                            showDragHandle: true,
                            builder: (BuildContext context) => CreateTagModal(
                              tagId: widget.tagId,
                              preEnteredTitle: widget.tagTitle,
                              preEnteredDescription: description,
                              exists: true,
                              thoseInvited: thoseInvited, //also, toggles creator, Me
                            ),
                          );
                          },
                          text: 'Edit',
                          backgroundColor: neutralGrey,
                        )),
                    ModalBottomButton(
                        onTap: widget.isCreator ? () {
                          showCupertinoDialog(
                            context: context,
                            builder: (context) => DefaultTwoOptionDialog(
                              title: 'Are you sure?',
                              content: 'Are you sure you want to disband this tag?',
                              optionOneText: 'Yes',
                              optionTwoText: 'No',
                              onOptionOne: () => {
                                // Update relevant documents from backend
                                disbandTag(widget.tagId),                      
                                // Close alert
                                Navigator.pop(context),
                                // Close modal
                                Navigator.pop(context),
                              },
                              onOptionTwo: () => Navigator.pop(context),
                            ),
                          );
                        } : widget.isMember ? () {
                          showCupertinoDialog(
                            context: context,
                            builder: (context) => DefaultTwoOptionDialog(
                              title: 'Are you sure?',
                              content: 'Are you sure you want to leave this tag?',
                              optionOneText: 'Yes',
                              optionTwoText: 'No',
                              onOptionOne: () => {
                                // Update relevant documents from backend
                                leaveTag(widget.tagId),                      
                                // Close alert
                                Navigator.pop(context),
                                // Close modal
                                Navigator.pop(context),
                              },
                              onOptionTwo: () => Navigator.pop(context),
                            ),
                          );
                        } : () {
                          // Update relevant documents in backend
                          joinTag(widget.tagId);
                          // Close modal
                          Navigator.pop(context);
                        }, //Replace this with notification if isMember, else nothing
                        text: widget.isCreator ? 'Disband' : widget.isMember ? 'Leave' : 'Join',
                        backgroundColor:
                            widget.isMember ? attendingOrange : absentRed),
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
