import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../src/colors.dart';

class EventAddressForm extends StatelessWidget {
  final String defaultText;
  EventAddressForm({
    super.key,
    required this.defaultText,
  });

/*
  final _geoMethods = GeoMethods(
    googleApiKey: 'AIzaSyCGJzUSDbjILqXm178DgHCGzMQTSb_RXTs',
    language: 'en',
    countryCode: 'us',
    country: 'United States',
    //city: 'Boston',
  );
  */

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
            defaultText,
            style: const TextStyle(
              color: Color.fromARGB(255, 128, 128, 128),
            ),
          ),
        ),
      ),
      onPressed: () => showDialog(
        context: context,
        builder: (BuildContext context) => const AlertDialog(
          content: DecoratedBox(
            decoration: BoxDecoration(),
            //child: Text('Hello!!'),
          ),
        ),
      ),
    );
  }
}
