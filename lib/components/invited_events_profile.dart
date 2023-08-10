import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../src/colors.dart';
import 'menu_event_widget.dart';

// Widget that streams public events to profile page
class InvitedEventsProfile extends StatefulWidget {

  const InvitedEventsProfile ({
    super.key,
  });

  @override
  State<InvitedEventsProfile> createState() => _AttendingEventsProfileState();
}

class _AttendingEventsProfileState extends State<InvitedEventsProfile> {
  
  // Retrieve uid of current user
  String uid = FirebaseAuth.instance.currentUser!.uid;

  // Retrieve all public events from Firestore
  final Query<Map<String, dynamic>> publicEvents = FirebaseFirestore.instance.collection('Events').where('isPrivate', isEqualTo: true);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: publicEvents.snapshots(),
      builder: (context, snapshot) {
        // What to show if waiting for data
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
            
            // Get List of relevant events from backend
            final List<QueryDocumentSnapshot<Object?>> documentSnapshots = snapshot.data!.docs;
            
            // Get number of events in list
            int numEvents = snapshot.data!.docs.length;
            
            // Initialize empty list of event widgets
            List<Widget> menuEventWidgets = [];

            // Add event widgets to list, pulling relevant info for each one
            if (numEvents > 0) {for (int i = 0; i<numEvents; i++) {
            final QueryDocumentSnapshot<Object?> eventDetails = documentSnapshots[i];
              menuEventWidgets.add(
                MenuEventWidget(
                  eventTitle: eventDetails['eventTitle'],
                  eventCreator: eventDetails['creator'],
                  isCreator: false,
                  isMember: false,
                )
              );
            }
              return Column(children: menuEventWidgets,);
            } else {
              return const Padding(
                padding: EdgeInsets.fromLTRB(0,10,0,15),
                child: Text(
                  "When you are invited to events, and tags, they'll appear here :)",
                  style: TextStyle(
                    color: absentRed,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              );
            } 
          }
          return const Center(child: Text("No Data Received"));
        }
        return Center(child: Text(snapshot.connectionState.toString()));
      }
    );
  }
}
