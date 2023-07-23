//import 'dart:async';
import 'package:auth_test/src/location_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../src/colors.dart';

class EventAddressForm extends StatefulWidget {
  final String defaultText;
  EventAddressForm({
    super.key,
    required this.defaultText,
  });

  @override
  State<EventAddressForm> createState() => _EventAddressFormState();
}

class _EventAddressFormState extends State<EventAddressForm> {
  //This is specifically for mmodal to edit address
  TextEditingController _addressSearchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      child: Container(
        decoration: const BoxDecoration(
          color: backgroundWhite,
          borderRadius: BorderRadiusDirectional.all(
            Radius.circular(7),
          ),
        ),
        child: Padding(
          // make this a reusable peice of code...
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            widget.defaultText,
            style: const TextStyle(
              color: Color.fromARGB(255, 128, 128, 128),
            ),
          ),
        ),
      ),
      onPressed: () => showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: DecoratedBox(
            decoration: const BoxDecoration(),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _addressSearchController,
                    decoration: const InputDecoration(
                      hintText: 'Enter new address...',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    print(LocationService()
                        .getPlace(_addressSearchController.text));
                  },
                  icon: const Icon(Icons.arrow_forward_ios_rounded),
                  color: attendingOrange,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}