import 'package:flutter/material.dart';

import '../components/address_list_entry.dart';
/* likely will need to make this widget able to build asynchronously... */

class AddressList extends StatelessWidget {
  //this probably needs to be made
  //into an async widget.
<<<<<<< HEAD
  final List<PlaceAutoComplete>? displayList;
  final TextEditingController relevantController;
  final dynamic updateSearchResult; //maybe make this non dynamic for speed.
  AddressList({
    super.key,
    required this.relevantController,
    this.displayList = const [],
    required this.updateSearchResult,
=======
  final List<String> displayList;
  const AddressList({
    super.key,
    required this.displayList,
>>>>>>> parent of a884ce8 (Updated Autocomplete)
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
<<<<<<< HEAD
          .map((fullAddress) => AddressListEntry(
                place: fullAddress,
                onTap: () => {
                  relevantController.text = fullAddress.address,
                  updateSearchResult(fullAddress.address),
                },
              ))
=======
          .map((fullAddress) => AddressListEntry(text: fullAddress))
>>>>>>> parent of a884ce8 (Updated Autocomplete)
          .toList(),
    );
  }
}
