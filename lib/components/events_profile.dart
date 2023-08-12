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

  // Retrieve all of current user's events data
  CollectionReference<Map<String, dynamic>> currentUserEvents = FirebaseFirestore.instance
    .collection('Users')
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .collection('MyEvents');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: currentUserEvents
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
            try {
              // Save set of MyEvents user is attending
              List<Widget> attendingEventWidgets = snapshot.data!.docs.map((event) {
                return MenuEventWidget(
                  eventTitle: event['eventTitle'],
                  eventCreator: event['creator'],
                  isCreator: event['creator'] == uid,
                  isAttending: widget.isAttending,
                );
              }).toList();

              if (attendingEventWidgets.isEmpty) {
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
              return Column(children: attendingEventWidgets,);

            } catch (e) {
              print('$e');
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
        return Center(child: Text(snapshot.connectionState.toString()));
      }
    );
  }
}
