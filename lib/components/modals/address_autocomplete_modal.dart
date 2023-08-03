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
                  onChanged: updateSearchResults,
                  decoration: const InputDecoration(
                    hintText: 'Enter new address...',
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  if (selectedPlace == null) {
                    Navigator.pop(context);
                  } else {
                    widget.setExternalSelectedPlace(selectedPlace!);
                    Navigator.pop(context);
                  }
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
