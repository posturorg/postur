import 'package:flutter/material.dart';

import '../components/address_list_entry.dart';
/* likely will need to make this widget able to build asynchronously... */

class AddressList extends StatelessWidget {
  //this probably needs to be made
  //into an async widget.
  final List<String> displayList;
  const AddressList({
    super.key,
    required this.displayList,
  });

  @override
  Widget build(BuildContext context) {
    late List<String> internalSublist;
    if (displayList.length < 5) {
      internalSublist = displayList;
    } else {
      internalSublist = displayList.sublist(0, 5);
    }
    //print(internalSublist);
    return Column(
      //This column doesnt seem to be causing the issue.
      children: internalSublist
          .map((fullAddress) => AddressListEntry(text: fullAddress))
          .toList(),
    );
  }
}
