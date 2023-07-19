import 'package:address_search_field/address_search_field.dart';
import 'package:auth_test/src/colors.dart';
import 'package:flutter/material.dart';

class EventAddressForm extends StatelessWidget {
  final String defaultText;
  EventAddressForm({
    super.key,
    required this.defaultText,
  });

  final _geoMethods = GeoMethods(
    googleApiKey: 'AIzaSyCGJzUSDbjILqXm178DgHCGzMQTSb_RXTs',
    language: 'en',
    countryCode: 'us',
    country: 'United States',
    //city: 'Boston',
  );
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText:
            defaultText, //This, of course, should be the address of our placed pin.
        border: const OutlineInputBorder(), // Customize the border style
      ),
      controller: _controller,
      onTap: () => showDialog(
        context: context,
        builder: (_) => AddressSearchDialog(
          geoMethods: _geoMethods,
          controller: _controller,
          onDone: (Address address) {
            //This is where we would have a function to change the map's center
            //of view, but keep the zoom level the same (maybe).
            print(address);
          },
          style: const AddressDialogStyle(
            color: attendingOrange,
          ),
        ),
      ),
    );
  }
}
