import 'package:auth_test/src/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ScanResult extends StatefulWidget {
  final String eventId;
  final String? userId;

  const ScanResult({
    super.key,
    required this.eventId,
    required this.userId,
  });

  @override
  State<ScanResult> createState() => _ScanResultState();
}

class _ScanResultState extends State<ScanResult> {
  // Initialize variables
    String fullName = ''; 
  // User's full name
    String username = ''; 
  // username
    String eventTitle = '';
  // Event title
    bool isOnList = false;

    // Get Creator Name
  Future<void> _getAttendeeInfo() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userId)
          .get();
      if (snapshot.exists) {
        setState(() {
          fullName = '${snapshot['name']['first']} ${snapshot['name']['last']}';
          username = snapshot['username'];
        });
      }
    } catch (e) {
      print("Error getting attendee's name: $e");
    }
  }

  // Get Event Data Name
  Future<void> _getEventTitle() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Events')
          .doc(widget.eventId)
          .get();
      if (snapshot.exists) {
        setState(() {
          eventTitle = snapshot['eventTitle'];
        });
      }
    } catch (e) {
      print("Error getting event info: $e");
    }
  }

  // Check if attendee is on the list
  Future<void> _getIsOnList() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('Events')
          .doc(widget.eventId)
          .collection('Invited')
          .doc(widget.userId)
          .get();
    
    if (snapshot.exists) {
      // Map eventData = snapshot.data as Map<String, dynamic>;
      if (snapshot['isAttending'] == true) {
        setState(() {
          isOnList = true;
        });
      } else {
        return;
      }
    } else {
      return;
    }      
    } catch (e) {
      print("Error checking if attendee is on the list: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _getAttendeeInfo();
    _getEventTitle();
    _getIsOnList();
  }

  @override
  Widget build(BuildContext context) {   
    
    late Color alertColor;
    isOnList ? alertColor = Colors.green : alertColor = absentRed;

    return AlertDialog(
      backgroundColor: alertColor,
      title: Column(
        children: [
          // IconButton(
          //   icon: mutualEvents ? const Icon(Icons.check_circle_outline, color: backgroundWhite) : const Icon(Icons.cancel_outlined, color: backgroundWhite),
          //   onPressed: () => Navigator.pop(context),
          //   iconSize: 100,
          // ),
          Icon(
            isOnList ? Icons.check_circle_outline : Icons.cancel_outlined,
            size: 150.0,
            color: backgroundWhite,
          ),
          Text(
            fullName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: backgroundWhite,
              fontSize: 20,
            ),
          ),
          Text(
            username,
            style: const TextStyle(
              color: backgroundWhite,
              fontSize: 15,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
            child: Column(
              children: [
                Text(
                  isOnList ? 'On the list for:' : 'NOT on the list for:',
                  style: const TextStyle(
                    color: backgroundWhite,
                    fontSize: 18,
                  ),
                ),
                Text(
                  eventTitle,
                  style: const TextStyle(
                    color: backgroundWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      content: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          padding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          backgroundColor: backgroundWhite,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)),
          elevation: 0.0,
        ),
        child: Text("OK",style: TextStyle(fontSize: 16, color: alertColor, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
