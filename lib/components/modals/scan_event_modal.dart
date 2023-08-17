import 'package:auth_test/components/scan_event_entry.dart';
import 'package:auth_test/src/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ScanForEventModal extends StatefulWidget {
  // will likely need to
  // make this stateful, but no matter!

  const ScanForEventModal({
    super.key,
  });

  @override
  State<ScanForEventModal> createState() =>
      _ScanForEventModalState();
}

class _ScanForEventModalState extends State<ScanForEventModal> {

  // Retrieve current user ID
  String uid = FirebaseAuth.instance.currentUser!.uid;

  Future<List<QueryDocumentSnapshot>> fetchEventData() async {
    final querySnapshot = await FirebaseFirestore.instance
      .collection('EventMembers')
      .doc(uid)
      .collection('MyEvents')
      .where('isAttending', isEqualTo: true)
      .get();

    return querySnapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(),
      child: Column(
        //This column is the issue
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Select the event\n you want to scan for',
            textAlign: TextAlign.center,
            style: TextStyle(
              //Centralize these
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          SizedBox(
            width: 200.0,
            height: 250.0,
            child: FutureBuilder<List<QueryDocumentSnapshot>>(
              future: fetchEventData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                
                // Store documents of all events user is attending
                final eventDocs = snapshot.data!;

                // Sort the eventDocs list alphabetically by eventTitle
                eventDocs.sort((a, b) {
                  final aData = a.data() as Map<String, dynamic>;
                  final bData = b.data() as Map<String, dynamic>;
                  final aTitle = aData['eventTitle'] as String;
                  final bTitle = bData['eventTitle'] as String;
                  return aTitle.compareTo(bTitle);
                });

                if (eventDocs.isEmpty) {
                  return const Text(
                  "When you RSVP to events, \nthey'll appear here :)",
                  textAlign: TextAlign.center,
                );
                } else {
                  return ListView.builder(
                  itemCount: eventDocs.length,
                  itemBuilder: (context, index) {
                    final eventData = eventDocs[index].data() as Map<String, dynamic>;
                    final eventId = eventData['eventId'];
                    final eventTitle = eventData['eventTitle'];

                    return ScanEventEntry(eventId: eventId, eventTitle: eventTitle);
                  },
                );
                }
              }
            ),
          ),
        ],
      ),
    );
  }
}
