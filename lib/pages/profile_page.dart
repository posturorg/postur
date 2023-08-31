import 'package:auth_test/components/id_widget.dart';
import 'package:auth_test/components/events_profile.dart';
import 'package:auth_test/components/profile_buttons.dart';
import 'package:auth_test/components/your_tags.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../src/colors.dart';
import '../components/tag_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Retrieve uid of current user
  String uid = FirebaseAuth.instance.currentUser!.uid;

  // Retrieve current user data from Firestore
  final currentUser = FirebaseFirestore.instance
      .collection('Users')
      .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid);

  // Retrieve all public events from Firestore
  final publicEvents = FirebaseFirestore.instance
      .collection('Events')
      .where('isPrivate', isEqualTo: false);

  @override
  Widget build(BuildContext context) {
    // Borders around "Attending" and "Invites" titles widgets
    BoxDecoration sectionBoxDecoration() {
      return const BoxDecoration(
        border: Border(
            top: BorderSide(
          color: backgroundWhite,
          width: 1.0,
        )),
      );
    }

    // Widget containing "Attending" title and the border above it
    Widget attendingTitle = Container(
      decoration: sectionBoxDecoration(),
      padding: const EdgeInsets.fromLTRB(20, 10, 25, 0),
      child: const Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Attending:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: attendingOrange,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    // Widget containing "Invites" title and the border above it
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
      ])
    );

    // Widget containing "Events" subtitle under Invites
    Widget inviteEventsTitle = Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 25, 0),
      child: const Row(children: [
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Events',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationColor: absentRed,
                  color: absentRed,
                )),
          ]),
        ),
      ])
    );

    // Widget containing "Events" subtitle under Invites
    Widget inviteTagsTitle = Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 25, 0),
      child: const Row(children: [
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Tags',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationColor: absentRed,
                  color: absentRed,
                )),
          ]),
        ),
      ])
    );

    return ListView(
      children: [
        Column(
          children: [
            // Stream of user data for ID Widget (QR Code, profile pic, name, username)
            IDStream(currentUser: currentUser),
            const ProfileButtons(),
            attendingTitle,
            const EventsProfile(isAttending: true),
            inviteTitle,
            inviteEventsTitle,
            const EventsProfile(isAttending: false),
            inviteTagsTitle,
            const YourTags(isMember: false),
          ],
        ),
      ],
    );
  }
}
