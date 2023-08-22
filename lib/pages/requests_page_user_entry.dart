import 'package:auth_test/src/colors.dart';
import 'package:flutter/material.dart';

BoxDecoration attendingBoxDecoration() {
  // this is repeated multiple times. perhaps put is somewhere more universal...
  return const BoxDecoration(
    border: Border(
        /*top: BorderSide(
            color: Color.fromARGB(255, 230, 230, 229),
            width: 1.0,
          ),*/
        bottom: BorderSide(
      color: Color.fromARGB(255, 230, 230, 229),
      width: 1.0,
    )),
  );
}

class RequestsPageUserEntry extends StatelessWidget {
  final Map<String, dynamic> user;
  const RequestsPageUserEntry({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: attendingBoxDecoration(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          const Icon(
            Icons.circle, //User profile picture goes here...
            size: 50,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
            child: Text(
              '${user['name']['first']} ${user['name']['last']}',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.check, color: attendingOrange),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.close_rounded, color: neutralGrey),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
