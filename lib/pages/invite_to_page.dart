import 'dart:async';

import 'package:auth_test/components/invite_tag_to_event.dart';
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
  final void Function(Set<String>, Set<String>) onBottomButtonPress;
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
  //TODO: Implement full name and tagname search
  //use these bools to filter results more accurately
  bool searchStartsWithHashtag = false;
  //use these bools to filter results more accurately

  final String currentUid = FirebaseAuth.instance.currentUser!.uid;
  final TextEditingController searchController = TextEditingController();
  Set<String> usersToBeInvited =
      {}; //Set of uid strings. (Need to make tag strings too)
  Set<String> tagsToBeInvited =
      {}; //Set of tag id strings. (Need to make tag strings too)

  late List<Stream<QuerySnapshot<Object?>>> streams;
  Timer? debounceSearch; //search bar debouncer

  late void Function(String queryText)
      onSearchChange; //to be called when searchbar changes

  String searchText = '';

  Future<Set<String>> getTagActives(String tagId) async {
    var membersCollection = FirebaseFirestore.instance
        .collection('Tags')
        .doc(tagId)
        .collection('Members');

    var activeMemberSnapshot = await membersCollection
        .where(
          'isMember',
          isEqualTo: true,
        )
        .get();

    var activeMemberUids =
        activeMemberSnapshot.docs.map((doc) => doc['uid'] as String).toSet();
    return activeMemberUids;
  }

  @override
  void initState() {
    usersToBeInvited = Set<String>.from(widget.usersAlreadyInvited);
    if (widget.toEvent) {
      tagsToBeInvited = Set<String>.from(widget.tagsAlreadyInvited);
      streams = [
        FirebaseFirestore.instance.collection('Users').limit(40).snapshots(),
        FirebaseFirestore.instance.collection('Tags').limit(40).snapshots(),
      ];
    } else {
      streams = [
        FirebaseFirestore.instance.collection('Users').limit(40).snapshots(),
        FirebaseFirestore.instance.collection('Tags').limit(1).snapshots(),
      ];
    }
    onSearchChange = (queryText) {
      //declaring onSearchChange
      if (debounceSearch?.isActive ?? false) debounceSearch?.cancel();
      debounceSearch = Timer(const Duration(milliseconds: 500), () {
        if (searchText != queryText) {
          setState(() {
            streams = completeSearch(queryText);
            searchText = queryText;
            if (queryText.isNotEmpty) {
              searchStartsWithHashtag = queryText[0] == '#';
            } else {
              searchStartsWithHashtag = false;
            }
          });
        }
      });
    };
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
          MySearchBar(
            searchController: searchController,
            onChanged: onSearchChange,
          ),
          const Divider(color: Color.fromARGB(255, 230, 230, 229)),
          Expanded(
            child: Stack(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: streams[0],
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
                    // usersDocs.sort(
                    //     (a, b) => a['name']['first'] //maybe dont do this...
                    //         .toString()
                    //         .compareTo(b['name']['first'].toString()));
                    late List<Map<String, dynamic>> userList = usersDocs
                        .map(
                            (userDoc) => userDoc.data() as Map<String, dynamic>)
                        .toList();
                    userList.removeWhere((user) => user['uid'] == currentUid);

                    return StreamBuilder(
                      stream: streams[1],
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator(
                            color: attendingOrange,
                          ); // Loading indicator
                        }
                        final tagsDocs = snapshot.data!.docs;
                        late List<Map<String, dynamic>> tagsList;

                        if (widget.toEvent) {
                          tagsList = tagsDocs
                              .map((tagDoc) =>
                                  tagDoc.data() as Map<String, dynamic>)
                              .toList();
                        } else {
                          tagsList = [];
                        }
                        List<Map<String, dynamic>> renderList =
                            List.from(userList)
                              ..addAll(tagsList); //maybe make final?

                        return ListView.builder(
                          itemCount: renderList.length,
                          itemBuilder: (context, index) {
                            final bool userEntry =
                                renderList[index].containsKey('uid');
                            if (userEntry) {
                              String uid = renderList[index]['uid'];
                              return Visibility(
                                visible: !searchStartsWithHashtag,
                                child: InviteToEventEntry(
                                  //user entry here
                                  user: renderList[index],
                                  selected: usersToBeInvited.contains(uid),
                                  onSelect: () {
                                    setState(() {
                                      usersToBeInvited.add(uid);
                                    });
                                  },
                                  onDeselect: () {
                                    setState(() {
                                      usersToBeInvited
                                          .removeWhere((item) => item == uid);
                                    });
                                  },
                                ),
                              );
                            } else {
                              String tagId = renderList[index]['tagId'];
                              return Visibility(
                                visible: widget.toEvent,
                                child: InviteTagToEventEntry(
                                  tag: renderList[index],
                                  selected: tagsToBeInvited.contains(tagId),
                                  onSelect: () async {
                                    var activeMemberUids =
                                        await getTagActives(tagId);

                                    Set<String> newUsersToBeInvited =
                                        usersToBeInvited;

                                    for (String uid in activeMemberUids) {
                                      newUsersToBeInvited.add(uid);
                                    }

                                    //also add all users in the tag to the event
                                    setState(() {
                                      tagsToBeInvited.add(tagId);
                                      usersToBeInvited = newUsersToBeInvited;
                                    });
                                  },
                                  onDeselect: () async {
                                    var activeMemberUids =
                                        await getTagActives(tagId);
                                    Set<String> newUsersToBeInvited =
                                        usersToBeInvited;
                                    for (String uid in activeMemberUids) {
                                      newUsersToBeInvited
                                          .removeWhere((item) => item == uid);
                                    }

                                    setState(() {
                                      tagsToBeInvited
                                          .removeWhere((item) => item == tagId);
                                      usersToBeInvited = newUsersToBeInvited;
                                    });
                                  },
                                ),
                              );
                            }
                          },
                        );
                      },
                    );
                  },
                ),
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
                            widget.onBottomButtonPress(
                                usersToBeInvited, tagsToBeInvited);
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
