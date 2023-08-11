import 'package:auth_test/components/my_searchbar.dart';
import 'package:auth_test/pages/requests_page_user_entry.dart';
import 'package:auth_test/src/colors.dart';
import 'package:flutter/material.dart';

class RequestsPage extends StatefulWidget {
  final String tagName;
  const RequestsPage({
    super.key,
    required this.tagName,
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
          "#${widget.tagName} Requests",
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
          Expanded(
            child: ListView.builder(
              itemCount: testListOfUsers.length,
              itemBuilder: (context, index) {
                return RequestsPageUserEntry(user: testListOfUsers[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
