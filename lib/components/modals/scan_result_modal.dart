import 'package:auth_test/src/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScanResult extends StatelessWidget {
  final String fullName;
  final String userName;
  final bool mutualEvents;

  const ScanResult({
    super.key,
    required this.fullName,
    required this.mutualEvents,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    Color alertColor;
    mutualEvents ? alertColor = Colors.green : alertColor = absentRed;

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
            mutualEvents ? Icons.check_circle_outline : Icons.cancel_outlined,
            size: 100.0,
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
            '@$userName',
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
                  mutualEvents ? 'Attending:' : '',
                  style: const TextStyle(
                    color: backgroundWhite,
                    fontSize: 18,
                  ),
                ),
                Text(
                  mutualEvents ? 'Mutual Events' : 'No Mutual Events',
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
        child: Text("Done",style: TextStyle(fontSize: 16, color: alertColor, fontWeight: FontWeight.bold)),
      ),
      
       
    //   actions: [
    // TextButton(
    //     onPressed: () =>
    //         Navigator.pop(
    //             context),
    //     child: const Text(
    //         "OK",
    //         style: TextStyle(
    //           color:
    //               Colors.blue,
    //         ))),
    //   ]
    );
  }
}
