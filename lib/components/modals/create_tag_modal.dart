import 'package:auth_test/components/modal_bottom_button.dart';
import 'package:auth_test/src/colors.dart';
import 'package:auth_test/src/event_box_decoration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateTagModal extends StatefulWidget {
  final bool exists;
  final String? preEnteredTitle;
  final String? preEnteredDescription;
  
  const CreateTagModal({
    super.key,
    required this.exists,
    this.preEnteredTitle,
    this.preEnteredDescription,
  });

  @override
  State<CreateTagModal> createState() => _CreateTagModalState();
}

class _CreateTagModalState extends State<CreateTagModal> {
  final TextEditingController tagTitleController = TextEditingController();

  final TextEditingController tagDescriptionController =
      TextEditingController();

  // text style... maybe put this in one central file.
  final TextStyle defaultBold = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 15,
  );

  final TextStyle defaultBody = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 15,
  );

  //more styling
  final EdgeInsets centralEdgeInset = const EdgeInsets.fromLTRB(20, 0, 20, 0);

  // Retrieve current user ID
  String uid = FirebaseAuth.instance.currentUser!.uid;

  // Retrieve current user document
  DocumentReference<Map<String, dynamic>> currentUser = FirebaseFirestore
      .instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  // Retrieve events data in order to update it in Firestore
  CollectionReference tags = FirebaseFirestore.instance.collection('Tags');

  Future<void> createTag() async {
    // Create a new document reference with an auto-generated ID
    DocumentReference newTagRef = tags.doc();

    // Get the auto-generated ID as a string
    String tagId = newTagRef.id;

    // Collect Tag info
    Map<String, dynamic> tagDetails = {
      'creator': uid,
      'tagId': tagId,
      'tagTitle': tagTitleController.text,
      'description': tagDescriptionController.text,
    };
    
    // Add tag to current user's "MyTags" subcollection in "TagMembers"
    Map<String, dynamic> tagMemberDetails = {
      'creator': uid,
      'tagId': tagId,
      'tagTitle': tagTitleController.text,
      'isCreator': true,
    };


    Map<String, dynamic> tagMemberList = {
      'uid': uid,
    };

    // Create new document in "MyTags" subcollection with tagId
    DocumentReference newMyTagRef = FirebaseFirestore.instance
        .collection('TagMembers')
        .doc(uid)
        .collection('MyTags')
        .doc(tagId);

    // Create new document in "Members" subcollection with tagId
    DocumentReference newMemberRef = FirebaseFirestore.instance.collection('Tags').doc(tagId).collection('Members').doc(uid);

    // Create "Tags" doc using "set" function
    await newTagRef.set(tagDetails);
    // Create "MyTags" doc using "set" function
    await newMyTagRef.set(tagMemberDetails);
    // Create "Members" doc using "set" function
    await newMemberRef.set(tagMemberList);

    print('Tag added with ID: ${newTagRef.id}');
  }

  @override
  Widget build(BuildContext context) {
    if (widget.preEnteredTitle != null) {
      tagTitleController.text = widget.preEnteredTitle!;
    }

    if (widget.preEnteredDescription != null) {
      tagDescriptionController.text = widget.preEnteredDescription!;
    }

    return SizedBox(
      height: 745, //Make this some fraction of the size of the safe area
      // also make this by default a function on whether or not you are
      // "focused" on the description editing box. Should be shorter when not
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Icon(
              Icons.circle,
              size: 85,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 0, 0, 2),
              child: TextField(
                controller: tagTitleController,
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
                  hintText:
                      '#EnterTagTitle...', //prevent spaces from being entered.
                  //Begin with a Hashtag...
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 11, 0, 0),
              child: Container(
                margin: centralEdgeInset,
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
                    minLines: 3,
                    maxLines: 3,
                    cursorColor: inputGrey,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter tag details...',
                      isCollapsed: true,
                    ),
                    maxLength: 130,
                    controller: tagDescriptionController,
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
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          TextSpan(
                            text: 'Invite: ',
                            style: defaultBold,
                          ),
                          TextSpan(
                            text: 'Function of peeps invited! Invite more...',
                            style: defaultBody,
                          ),
                        ],
                      ),
                    ),
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
                      onTap: () {
                        // Create new tag
                        createTag();
                        // Close modal
                        Navigator.pop(context);
                        }, //need to properly populate this...
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
