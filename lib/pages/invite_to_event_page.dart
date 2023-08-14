import 'package:auth_test/components/invite_to_event_entry.dart';
import 'package:auth_test/components/my_searchbar.dart';
import 'package:auth_test/src/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InviteToEventPage extends StatefulWidget {
  const InviteToEventPage({super.key});

  @override
  State<InviteToEventPage> createState() => _InviteToEventPageState();
}

class _InviteToEventPageState extends State<InviteToEventPage> {
  final TextEditingController searchController = TextEditingController();
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
                      final userList = usersDocs
                          .map((userDoc) =>
                              userDoc.data() as Map<String, dynamic>)
                          .toList();
                      return ListView.builder(
                        itemCount: userList.length,
                        itemBuilder: (context, index) {
                          return InviteToEventEntry(user: userList[index]);
                        },
                      );
                    }),
                //SHOULD NOT!!! PULL ALL USERS, JUST MAX OF LIKE 40 OF THEM
                /*ListView(
                  children: const [
                    InviteToEventEntry(
                      user: {
                        'first': 'Ben',
                        'last': 'du Pont',
                        'username': 'me'
                      },
                    )
                  ],
                ),*/
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
                            print('Add selected users to relevant event!');
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
