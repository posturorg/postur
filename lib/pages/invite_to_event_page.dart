import 'package:auth_test/components/my_searchbar.dart';
import 'package:auth_test/src/colors.dart';
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
            child: ListView.builder(
              itemCount: 0,
              itemBuilder: (context, index) {
                return const Scaffold();
              },
            ),
          )
        ],
      ),
    );
  }
}
