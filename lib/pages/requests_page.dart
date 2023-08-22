import 'package:auth_test/components/my_searchbar.dart';
import 'package:auth_test/pages/requests_page_user_entry.dart';
import 'package:auth_test/src/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RequestsPage extends StatefulWidget {
  final String tagId;
  final String tagTitle;

  const RequestsPage({
    super.key,
    required this.tagId,
    required this.tagTitle,
  });

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  TextEditingController searchController =
      TextEditingController(); //search controller initialized

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> testListOfUsers = [
      {
        'name': 'Benjamin',
        'userID': 'POjihniebfib',
        'profilePicture': 'www.google.com',
      },
      {
        'name': 'Alvin Adjei',
        'userID': 'qlkjbnlijerkfu',
        'profilePicture': 'www.google.com',
      },
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "#${widget.tagTitle} Requests",
          style: const TextStyle(
            color: attendingOrange,
            fontWeight: FontWeight.bold,
            fontSize: 21.5,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color:
                attendingOrange, //this should be a function of a parameter of
            //the widget, depending on if the user is already attending.
          ),
        ),
      ),
      body: Column(
        children: [
          MySearchBar(
            searchController: searchController,
          ),
          const Divider(color: Color.fromARGB(255, 230, 230, 229)), //Divider
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                        .collection('Tags')
                        .doc(widget.tagId)
                        .collection('Invited')
                        .where('isMember', isEqualTo: true)
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
                  final usersDocs = snapshot.data!.docs;
                  // Sort the documents by a specific field (e.g., 'name') alphabetically
                  usersDocs.sort((a, b) => a['name']['first']
                      .toString()
                      .compareTo(b['name']['first'].toString()));
                  final userList = usersDocs
                      .map((userDoc) =>
                          userDoc.data() as Map<String, dynamic>)
                      .toList();
                  return Expanded(
                    child: ListView.builder(
                      itemCount: userList.length,
                      itemBuilder: (context, index) {
                        return RequestsPageUserEntry(user: userList[index]);
                      },
                    ),
                  );
                }
              }
              return const Text("Don't worry, be happy :)");
            }
          ),
        ],
      ),
    );
  }
}
