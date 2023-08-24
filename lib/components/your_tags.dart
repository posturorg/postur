import 'package:auth_test/components/tag_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../src/colors.dart';

// Widget that streams public events to profile page
class YourTags extends StatefulWidget {
  final bool isMember;

  const YourTags({super.key, required this.isMember});

  @override
  State<YourTags> createState() => _YourTagsState();
}

class _YourTagsState extends State<YourTags> {
  // Retrieve uid of current user
  String uid = FirebaseAuth.instance.currentUser!.uid;

  // Retrieve current user document
  DocumentReference currentUser = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  // Retrieve current user's TagMembers data
  DocumentReference currentUserEvents = FirebaseFirestore.instance
      .collection('TagMembers')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  @override
  Widget build(BuildContext context) {
    try {
      return StreamBuilder<QuerySnapshot>(
          stream: currentUserEvents
              .collection('MyTags')
              .where('isMember', isEqualTo: widget.isMember)
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
                // Save list of MyTags user is invited to/a member of
                List<Widget> myTagWidgets = snapshot.data!.docs.map((tag) {
                  return TagWidget(
                    tagId: tag['tagId'],
                    tagCreator: tag['creator'],
                    isCreator: tag['isCreator'],
                    isMember: tag['isMember'],
                  );
                }).toList();

                if (myTagWidgets.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0, 12.5, 0, 12.5),
                    child: Text(
                      widget.isMember
                          ? "When you RSVP to events, \nthey'll appear here :)"
                          : "When you are invited to events or \ntags, they'll appear here :)",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: widget.isMember ? attendingOrange : absentRed,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  );
                }
                // Return
                return Column(
                  children: myTagWidgets,
                );
              }
            }
            return Center(child: Text(snapshot.connectionState.toString()));
          });
    } catch (e) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 15),
        child: Text(
          "When you are invited to events or tags, they'll appear here :)",
          style: TextStyle(
            color: attendingOrange,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      );
    }
  }
}
