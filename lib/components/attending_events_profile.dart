import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../src/colors.dart';
import 'menu_event_widget.dart';

// Widget that streams public events to profile page
class AttendingEventsProfile extends StatefulWidget {

  const AttendingEventsProfile ({
    super.key,
  });

  @override
  State<AttendingEventsProfile> createState() => _AttendingEventsProfileState();
}

class _AttendingEventsProfileState extends State<AttendingEventsProfile> {
  
  // Retrieve uid of current user
  String uid = FirebaseAuth.instance.currentUser!.uid;

  // Retrieve current user data
  DocumentReference currentUser = FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream:  currentUser.snapshots(),
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
              // Save set of eventId's user is attending
              Set attendingEventIds = snapshot.data!['attending'].toSet() ?? {};
              print(attendingEventIds.length);
              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('Events')
                  .where('eventId', whereIn: attendingEventIds)
                  /* TODO: Ordering by any field besides 'eventId' causes an error to occur! */ 
                  // .orderBy('eventId')
                  .snapshots(),
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
                      final List documentSnapshots= snapshot.data!.docs;

                      // Get number of events in list
                      int numEvents = snapshot.data!.docs.length;
                      
                      if (numEvents > 0) {
                        // Add event widgets to list, pulling relevant info for each one
                        List<Widget> attendingEventWidgets = documentSnapshots
                        .map((event) {
                          return MenuEventWidget(
                            eventTitle: event['eventTitle'],
                            eventCreator: event['creator'],
                            isCreator: event['creator'] == uid ? true : false,
                            isMember: true
                          );
                        }).toList();

                        return Column(children: attendingEventWidgets,);
                      } else {
                        return const Padding(
                          padding: EdgeInsets.fromLTRB(0,10,0,15),
                          child: Text(
                            "When you RSVP to events, they'll appear here :)",
                            style: TextStyle(
                              color: attendingOrange,
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
            } catch (e) {
              print('$e');
              return const Padding(
                padding: EdgeInsets.fromLTRB(0,10,0,15),
                child: Text(
                  "When you RSVP to events, they'll appear here :)",
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
        return Center(child: Text(snapshot.connectionState.toString()));
      }
    );
  }
}
