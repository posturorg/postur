//import 'dart:async';
//import 'package:auth_test/src/location_services.dart';
import 'package:auth_test/components/modals/address_autocomplete_modal.dart';
import 'package:auth_test/src/places/places_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../src/colors.dart';

class EventAddressForm extends StatefulWidget {
  final PlaceAutoComplete defaultPlace;
  final TextEditingController addressSearchController;
  final void Function(PlaceAutoComplete) setExternalSelectedPlace;
  const EventAddressForm({
    super.key,
    required this.defaultPlace,
    required this.addressSearchController,
    required this.setExternalSelectedPlace,
  });

  @override
  State<EventAddressForm> createState() => _EventAddressFormState();
}

class _EventAddressFormState extends State<EventAddressForm> {
  @override
  Widget build(BuildContext context) {
    PlaceAutoComplete selectedPlace = widget.defaultPlace;
    return CupertinoButton(
      child: Container(
        decoration: const BoxDecoration(
          color: backgroundWhite,
          borderRadius: BorderRadiusDirectional.all(
            Radius.circular(7),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Flexible(
            child: Text(
              selectedPlace.address,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color.fromARGB(255, 128, 128, 128),
              ),
            ),
          ),
        ),
      ),
      onPressed: () => showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: AddressAutocompleteModal(
            textController: widget.addressSearchController,
            setExternalSelectedPlace: widget.setExternalSelectedPlace,
          ),
        ),
      ),
    );
  }
}
