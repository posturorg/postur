import 'package:auth_test/components/invite_to_event_entry.dart';
import 'package:auth_test/components/my_searchbar.dart';
import 'package:auth_test/src/colors.dart';
import 'package:auth_test/src/search_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InviteToEventPage extends StatefulWidget {
  final Set<String>
      usersAlreadyInvited; // set of UID's already invited to event
  final Set<String> tagsAlreadyInvited;
  final bool toEvent;
  final void Function(Set<String>) onBottomButtonPress;
  const InviteToEventPage({
    super.key,
    required this.usersAlreadyInvited, // set of UID's already invited to event or tag
    required this.tagsAlreadyInvited, // set of tags already invited to event or tag
    required this.onBottomButtonPress,
    required this.toEvent, // if true, to event. false, to tag.
  });

  @override
  State<InviteToEventPage> createState() => _InviteToEventPageState();
}

class _InviteToEventPageState extends State<InviteToEventPage> {
  final String currentUid = FirebaseAuth.instance.currentUser!.uid;
  final TextEditingController searchController = TextEditingController();
  Set<String> usersToBeInvited =
      {}; //Set of uid strings. (Need to make tag strings too)
  Set<String> tagsToBeInvited =
      {}; //Set of tag id strings. (Need to make tag strings too)

  Stream<QuerySnapshot<Map<String, dynamic>>>
      stream = //set this to what it needs to be according to search bar
      FirebaseFirestore.instance.collection('Users').limit(40).snapshots();

  @override
  void initState() {
    usersToBeInvited = Set<String>.from(widget.usersAlreadyInvited);
    if (widget.toEvent) {
      tagsToBeInvited = Set<String>.from(widget.tagsAlreadyInvited);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Invite',
          style: TextStyle(
            color: attendingOrange,
            fontWeight: FontWeight.bold,
            fontSize: 21.5,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: attendingOrange,
          ),
          onPressed: () {
            Navigator.pop(context); //closes page
          },
        ),
      ),
      body: Column(
        children: [
          MySearchBar(searchController: searchController),
          const Divider(color: Color.fromARGB(255, 230, 230, 229)),
          Expanded(
            child: Stack(
              children: [
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Users')
                        .snapshots(), //function of search bar
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator(
                          color: attendingOrange,
                        ); // Loading indicator
                      }
                      final usersDocs = snapshot.data!.docs;
                      // Sort the documents by a specific field (e.g., 'name') alphabetically
                      usersDocs.sort((a, b) => a['name']['first']
                          .toString()
                          .compareTo(b['name']['first'].toString()));
                      List<Map<String, dynamic>> userList = usersDocs
                          .map((userDoc) =>
                              userDoc.data() as Map<String, dynamic>)
                          .toList();
                      userList.removeWhere((user) => user['uid'] == currentUid);
                      return ListView.builder(
                        itemCount: userList.length,
                        itemBuilder: (context, index) {
                          String uid = userList[index]['uid'];
                          return InviteToEventEntry(
                            user: userList[index],
                            selected: usersToBeInvited.contains(uid),
                            onSelect: () {
                              setState(() {
                                usersToBeInvited.add(uid);
                                //toBeInvited = toBeInvited;
                              });
                              //print(usersToBeInvited);
                            },
                            onDeselect: () {
                              setState(() {
                                usersToBeInvited
                                    .removeWhere((item) => item == uid);
                                //toBeInvited = toBeInvited;
                              });
                              //print(usersToBeInvited);
                            },
                          );
                        },
                      );
                    }),
                //SHOULD NOT!!! PULL ALL USERS, JUST MAX OF LIKE 40 OF THEM
                SafeArea(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: attendingOrange,
                          ),
                          onPressed: () {
                            widget.onBottomButtonPress(usersToBeInvited);
                            Navigator.pop(context); //goes back to modal.
                          },
                          child: Text(
                            widget.toEvent
                                ? 'Invite to event'
                                : 'Invite to tag',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        const SizedBox(height: 50)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
