import 'package:auth_test/src/places/places_repository.dart';
import 'package:flutter/material.dart';

import '../components/address_list_entry.dart';

class AddressList extends StatelessWidget {
  //this probably needs to be made
  //into an async widget.
  final List<PlaceAutoComplete>? displayList;
  final TextEditingController relevantController;
  final void Function(PlaceAutoComplete) setInternalSelectedPlace;
  final dynamic updateSearchResults;
  const AddressList({
    super.key,
    required this.relevantController,
    required this.updateSearchResults,
    required this.setInternalSelectedPlace,
    this.displayList = const [],
  });

  @override
  Widget build(BuildContext context) {
    late List<PlaceAutoComplete> internalSublist;
    if (displayList == null) {
      internalSublist = [];
    } else if (displayList!.length < 5) {
      internalSublist = displayList!;
    } else {
      internalSublist = displayList!.sublist(0, 5);
    }
    //print(internalSublist);
    return Column(
      //This column doesnt seem to be causing the issue.
      children: internalSublist
          .map((fullAddress) => AddressListEntry(
              place: fullAddress,
              onTap: () => {
                    relevantController.text = fullAddress.address,
                    updateSearchResults(fullAddress.address),
                    setInternalSelectedPlace(fullAddress),
                  }))
          .toList(),
    );
  }
}
