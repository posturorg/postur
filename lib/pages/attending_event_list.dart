import 'package:auth_test/components/my_searchbar.dart';
import 'package:auth_test/pages/attending_event_user_entry.dart';
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

  final ScrollController _scrollController = ScrollController();
  List<DocumentSnapshot> _dataList = [];
  bool _isFetchingData = false;

  @override
  void initState() {
    super.initState();
    alphabetizedDisplayList = sortUsersByName(widget.namesAttending);
    internalDisplayList = alphabetizedDisplayList;
    _fetchData();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.minScrollExtent) {
      // User has scrolled to the top
      _fetchData();
    }
  }

  Future<void> _fetchData() async {
    if (_isFetchingData) {
      return;
    }

    setState(() {
      _isFetchingData = true;
    });

    QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('Events')
      .doc(widget.eventId)
      .collection('Attending')
      .get();

    setState(() {
      _dataList.addAll(snapshot.docs);
      _isFetchingData = false;
    });
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
            child: ListView.builder(
              itemCount: internalDisplayList.length,
              itemBuilder: (context, index) {
                return AttendingEventUserEntry(
                  user: internalDisplayList[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
