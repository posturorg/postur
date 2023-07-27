import 'package:auth_test/src/places/places_repository.dart';
import 'package:flutter/material.dart';
//import '../src/colors.dart';

class AddressListEntry extends StatelessWidget {
  final PlaceAutoComplete place;
  final void Function()? onTap;
  const AddressListEntry({
    super.key,
    required this.place,
    required this.onTap,
  });

  BoxDecoration addressBoxDecoration() {
    return const BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Colors.black,
          width: 1.0,
        ),
      ),
    );
  }

  final double fromTopAndBottom = 15; //Essentially encodes vertical size of box

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // This is where our function will go to set text
      //controller's text to the selected entry's text.
      child: Container(
        //copy this into address autocomplete modal
        padding: EdgeInsets.fromLTRB(0, fromTopAndBottom, 0, fromTopAndBottom),
        decoration: addressBoxDecoration(),
        child: Row(
          children: [
            const Icon(Icons.place),
            Flexible(
              child: Container(
                padding: const EdgeInsets.fromLTRB(7, 0, 20, 0),
                child: Text(
                  place.address,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
