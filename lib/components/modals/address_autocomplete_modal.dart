import 'package:auth_test/components/address_list.dart';
import 'package:auth_test/src/colors.dart';
import 'package:flutter/material.dart';

class AddressAutocompleteModal extends StatefulWidget {
  // will likely need to
  // make this stateful, but no matter!
  final TextEditingController textController;
  final void Function(PlaceAutoComplete) selectedPlaceSetter;
  const AddressAutocompleteModal({
    super.key,
    required this.textController,
    required this.selectedPlaceSetter,
  });

  @override
  State<AddressAutocompleteModal> createState() =>
      _AddressAutocompleteModalState();
}

class _AddressAutocompleteModalState extends State<AddressAutocompleteModal> {
<<<<<<< HEAD
  List<PlaceAutoComplete>? displayList = [];

  void updateSearchResults(String? query) async {
    //experiment with this being async or not
    if (query == '') {
      displayList = [];
    } else if (query == null) {
      //perhaps this is a bit verbose
      displayList = [];
    } else {
      PlacesRepository().getAutoComplete(query).then((results) {
        setState(() {
          displayList = results;
        });
      });
    }
  }

=======
  List<String> displayList = [];
>>>>>>> parent of a884ce8 (Updated Autocomplete)
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(),
      child: Column(
        //This column is the issue
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.textController,
                  onChanged: (textVal) async {
                    print(textVal);
                  },
                  decoration: const InputDecoration(
                    hintText: 'Enter new address...',
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
<<<<<<< HEAD
                  //experiment with making this async or not.
                  //likely will need fixing.
                  if (widget.textController.text == '') {
                  } else if (displayList == []) {
                    updateSearchResults(widget.textController.text);
                    if (displayList == []) {
                      // Navigator.pop(context);
                    } else {
                      widget.textController.text = displayList![0].address;
                      widget.selectedPlaceSetter(displayList![0]);
                      // Navigator.pop(context);
                    }
                  } else {
                    updateSearchResults(widget.textController.text);
                    widget.textController.text = displayList![0].address;
                    widget.selectedPlaceSetter(displayList![0]);
                  }
=======
>>>>>>> parent of a884ce8 (Updated Autocomplete)
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_forward_ios_rounded),
                color: attendingOrange,
              )
            ],
          ),
          AddressList(
            displayList: displayList,
<<<<<<< HEAD
            relevantController: widget.textController,
            updateSearchResult: updateSearchResults,
=======
>>>>>>> parent of a884ce8 (Updated Autocomplete)
          ), //Ultimately, this must be passed the proper args.
          const SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }
}
