import 'package:auth_test/components/invite_to_event_entry.dart';
import 'package:auth_test/components/my_searchbar.dart';
import 'package:auth_test/src/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InviteToEventPage extends StatefulWidget {
  final Set<String> alreadyInvited; // set of UID's already invited to event
  final void Function(Set<String>) onBottomButtonPress;
  const InviteToEventPage({
    super.key,
    required this.alreadyInvited, // set of UID's already invited to event
    required this.onBottomButtonPress,
  });

  @override
  State<InviteToEventPage> createState() => _InviteToEventPageState();
}

class _InviteToEventPageState extends State<InviteToEventPage> {
  final TextEditingController searchController = TextEditingController();
  Set<String> toBeInvited =
      {}; //Set of uid strings. (Need to make tag strings too)
 
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    toBeInvited = Set<String>.from(widget.alreadyInvited);
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
                        .where('uid', isNotEqualTo: uid)
                        .snapshots(),
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
                      final userList = usersDocs
                          .map((userDoc) =>
                              userDoc.data() as Map<String, dynamic>)
                          .toList();
                      return ListView.builder(
                        itemCount: userList.length,
                        itemBuilder: (context, index) {
                          String uid = userList[index]['uid'];
                          return InviteToEventEntry(
                            user: userList[index],
                            selected: toBeInvited.contains(uid),
                            onSelect: () {
                              setState(() {
                                toBeInvited.add(uid);
                                //toBeInvited = toBeInvited;
                              });
                              print(toBeInvited);
                            },
                            onDeselect: () {
                              setState(() {
                                toBeInvited.removeWhere((item) => item == uid);
                                //toBeInvited = toBeInvited;
                              });
                              print(toBeInvited);
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
                            widget.onBottomButtonPress(toBeInvited);
                            Navigator.pop(context); //goes back to modal.
                          },
                          child: const Text(
                            'Add to event',
                            style: TextStyle(
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
