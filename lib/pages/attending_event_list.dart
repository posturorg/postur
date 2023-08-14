import 'package:auth_test/components/my_searchbar.dart';
import 'package:auth_test/components/attending_event_user_entry.dart';
import 'package:auth_test/src/colors.dart';
import 'package:auth_test/src/search_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AttendingEventList extends StatefulWidget {
  final String eventId;
  final bool isAttending;
  final List<Map<String, String>> namesAttending;

  const AttendingEventList({
    super.key,
    required this.eventId,
    required this.isAttending,
    required this.namesAttending,
  });

  @override
  State<AttendingEventList> createState() => _AttendingEventListState();
}

final TextEditingController searchController =
    TextEditingController(); //controller of search bar...

late List<String> namesAttendingAlphabetized;
late List<Map<String, String>> internalDisplayList;
late List<Map<String, String>> alphabetizedDisplayList;

class _AttendingEventListState extends State<AttendingEventList> {

  @override
  void initState() {
    super.initState();
    alphabetizedDisplayList = sortUsersByName(widget.namesAttending);
    internalDisplayList = alphabetizedDisplayList;
  }

  @override
  Widget build(BuildContext context) {
    Color detailsColor = widget.isAttending ? attendingOrange : absentRed;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Attending',
          style: TextStyle(
            color: detailsColor,
            fontWeight: FontWeight.bold,
            fontSize: 21.5,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: detailsColor, //this should be a function of a parameter of
            //the widget, depending on if the user is already attending.
          ),
        ),
      ),
      body: Column(
        children: [
          MySearchBar(
            searchController: searchController,
          ),
          const Divider(color: Color.fromARGB(255, 230, 230, 229)),
          Expanded(
            child: FutureBuilder<List<String>>(
              future: _fetchAttendees(widget.eventId),
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
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      String uid = snapshot.data![index];
                      return FutureBuilder<DocumentSnapshot>(
                        future: _fetchUserData(uid),
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
                              if (snapshot.hasError) {
                                return const Center(child: Text("Error Occured"));
                              } else if (snapshot.hasData) {
                                return AttendingEventUserEntry(
                                  user: snapshot.data!,
                                );
                              }
                          }
                          return const Center( child: Text('Attendee failed to load :('));
                        }
                      );
                    },
                  );
                }
              }
              return const Center( child: Text('No attendees found :('));
              }
            ),
          ),
        ],
      ),
    );
  }
}

// Fetch list of attendees' uid's
Future<List<String>> _fetchAttendees(String eventId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('Events')
      .doc(eventId)
      .collection('Attending')
      .get();

    List<String> attendees = querySnapshot.docs.map((doc) => doc.id).toList();
    return attendees;
  }

  // Fetch a document's data using uid
  Future<DocumentSnapshot> _fetchUserData(String uid) async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .get();

    return userSnapshot;
  }