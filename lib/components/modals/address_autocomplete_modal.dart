import 'dart:async';

import 'package:auth_test/components/address_list.dart';
import 'package:auth_test/src/colors.dart';
import 'package:auth_test/src/places/places_repository.dart';
import 'package:flutter/material.dart';

class AddressAutocompleteModal extends StatefulWidget {
  // will likely need to
  // make this stateful, but no matter!
  final TextEditingController textController;
  final void Function(PlaceAutoComplete) setExternalSelectedPlace;
  const AddressAutocompleteModal({
    super.key,
    required this.textController,
    required this.setExternalSelectedPlace,
  });

  @override
  State<AddressAutocompleteModal> createState() =>
      _AddressAutocompleteModalState();
}

class _AddressAutocompleteModalState extends State<AddressAutocompleteModal> {
  List<PlaceAutoComplete>? displayList = [];

  void updateSearchResults(String? query) async {
    //experiment with this being async or not
    PlacesRepository().getAutoComplete(query).then((results) {
      setState(() {
        displayList = results;
      });
    });
  }

  PlaceAutoComplete? selectedPlace;

  void setInternalSelectedPlace(PlaceAutoComplete newPlace) {
    setState(() {
      selectedPlace = newPlace;
      //print('Goooooober');
      //print(selectedPlace!.address);
    });
  }

  late void Function(String queryText) onSearchChange;
  Timer? debounceSearch;
  String searchText = ''; //need to make this a function of an input? maybe

  @override
  void initState() {
    onSearchChange = (queryText) {
      if (debounceSearch?.isActive ?? false) debounceSearch?.cancel();
      debounceSearch = Timer(const Duration(milliseconds: 500), () {
        if (searchText != queryText) {
          updateSearchResults(queryText);
          setState(() {
            searchText = queryText;
          });
        }
      });
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(),
      child: Column(
        //This column is the issue
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Where:',
            style: TextStyle(
              //Centralize these
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.textController,
                  onChanged: onSearchChange, //wrap in debouncer
                  decoration: const InputDecoration(
                    hintText: 'Enter new address...',
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  if (selectedPlace == null) {
                    if (widget.textController.text == '') {
                      //do nothing... fix this code structuring soon
                    } else {
                      List<PlaceAutoComplete>? internalList =
                          await PlacesRepository()
                              .getAutoComplete(widget.textController.text);
                      //print(internalList);
                      if (internalList!.isNotEmpty) {
                        widget.setExternalSelectedPlace(internalList[0]);
                      }
                    }
                  } else {
                    widget.setExternalSelectedPlace(selectedPlace!);
                  }
                  widget.textController.text = '';
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_forward_ios_rounded),
                color: attendingOrange,
              )
            ],
          ),
          AddressList(
            displayList: displayList,
            relevantController: widget.textController,
            updateSearchResults: updateSearchResults,
            setInternalSelectedPlace: setInternalSelectedPlace,
          ), //Ultimately, this must be passed the proper args.
          const SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }
}
