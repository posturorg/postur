import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../src/colors.dart';
import 'menu_event_widget.dart';

// Widget that streams public events to profile page
class EventsProfile extends StatefulWidget {
  final bool isAttending;

  const EventsProfile ({
    super.key,
    required this.isAttending
  });

  @override
  State<EventsProfile> createState() => _EventsProfileState();
}

class _EventsProfileState extends State<EventsProfile> {
  
  // Retrieve uid of current user
  String uid = FirebaseAuth.instance.currentUser!.uid;

  // Retrieve current user document
  DocumentReference currentUser = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.uid);
  
  // Retrieve current user's EventMembers data
  DocumentReference currentUserEvents = FirebaseFirestore.instance
      .collection('EventMembers')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  @override
  Widget build(BuildContext context) {
    try {
      return StreamBuilder<QuerySnapshot>(
        stream: currentUserEvents
          .collection('MyEvents')
          .where('isAttending', isEqualTo: widget.isAttending)
          .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show Waiting Indicator
            return const Center(child: CircularProgressIndicator(color: absentRed,));
          // What to show if data has been received
          } else if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
            // Potenital error message
            if (snapshot.hasError) {
              return const Center(child: Text("Error Occured"));
            // Success
            } else if (snapshot.hasData) {

              // Save list of MyEvents user is invited to/attending
              List<Widget> myEventWidgets = snapshot.data!.docs.map((event) {
                return MenuEventWidget(
                  eventId: event['eventId'],
                  eventCreator: event['creator'],
                  isCreator: event['isCreator'],
                  isAttending: event['isAttending'],
                );
              }).toList();

              if (myEventWidgets.isEmpty) {
                return Text(
                  widget.isAttending ? "When you RSVP to events, they'll appear here :)" : "When you are invited to events or tags, they'll appear here :)",
                  style: const TextStyle(
                    color: absentRed,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                );
              }
              // Return 
              return Column(children: myEventWidgets,);
            }
          }
          return Center(child: Text(snapshot.connectionState.toString()));
        }
      );
    } catch (e) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(0,10,0,15),
        child: Text(
          "When you are invited to events or tags, they'll appear here :)",
          style: TextStyle(
            color: absentRed,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      );
    }
  }
}
