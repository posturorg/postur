import 'package:auth_test/components/address_list_entry.dart';
import 'package:flutter/material.dart';
/* This is where the autocomplete list widget will go... */

class AddressList extends StatelessWidget {
  const AddressList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      //This column doesnt seem to be causing the issue.
      children: [
        AddressListEntry(text: 'text'),
        AddressListEntry(text: '7 Elm Meadow Grove, Grassland, DE 18342'),
        AddressListEntry(
            text:
                '11 Royal Palm Way, Apt. 43, Goosbury Avenue, Goosebury, CE 18773'),
        AddressListEntry(text: 'Sick'),
        AddressListEntry(text: 'Oopsy Daisy, Hello!'),
      ],
    );
  }
}
