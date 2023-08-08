import 'package:auth_test/components/id_widget.dart';
import 'package:auth_test/components/profile_buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../src/colors.dart';
import '../components/menu_event_widget.dart';
import '../components/tag_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  // Retrieve uid of current user
  String uid = FirebaseAuth.instance.currentUser!.uid;
  
  // Retrieve user data in order to update it in Firestore
  final currentUser = FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid);

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
        ]));

    return ListView(
      children: [
        Column(
          children: [
            // Stream of user data for ID Widget (QR Code, profile pic, name, username)
            StreamBuilder<Object>(
              stream: currentUser.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {  
                  /* TODO: access necessary data from streams */
                  // Map<String, dynamic> data = snapshot.data as Map<String, dynamic>;
                  return IDWidget(
                    firstName: 'Alvin',
                    lastName: 'Adjei',
                    userName: 'alldayadjei',
                    reference: 'hey',
                    uid: uid,
                  );
                } else {
                  return const Text('Loading...');
                }
              }
            ),
            const ProfileButtons(),
            attendingTitle,
            MenuEventWidget(
                eventTitle: 'Welding Club',
                eventCreator: 'Huds',
                isCreator: true,
                isMember: true),
            MenuEventWidget(
              eventTitle: "Pete's Bday Party",
              eventCreator: 'Me',
              isCreator: true,
              isMember: true,
            ),
            inviteTitle,
            MenuEventWidget(
              eventTitle: 'Booze Cruise',
              eventCreator: '@SigmaChi',
              isCreator: false,
              isMember: false,
            ),
            const TagWidget(
              tagTitle: 'Yale2024',
              tagCreator: '@YaleAdmins',
              isMember: false,
              isCreator: false,
            ),
          ],
        ),
      ],
    );
  }
}
