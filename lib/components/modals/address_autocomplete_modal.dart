import 'package:auth_test/components/address_list.dart';
import 'package:auth_test/src/colors.dart';
import 'package:flutter/material.dart';

class AddressAutocompleteModal extends StatefulWidget {
  // will likely need to
  // make this stateful, but no matter!
  final TextEditingController textController;
  const AddressAutocompleteModal({super.key, required this.textController});

  @override
  State<AddressAutocompleteModal> createState() =>
      _AddressAutocompleteModalState();
}

class _AddressAutocompleteModalState extends State<AddressAutocompleteModal> {
  List<String> displayList = [];
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
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_forward_ios_rounded),
                color: attendingOrange,
              )
            ],
          ),
          AddressList(
            displayList: displayList,
          ), //Ultimately, this must be passed the proper args.
          const SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }
}
