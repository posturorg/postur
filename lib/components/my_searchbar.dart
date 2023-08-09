import 'package:auth_test/src/colors.dart';
import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget {
  const MySearchBar({super.key});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
        child: Column(
          children: [
            SearchBar(
              backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => backgroundWhite),
              hintText: 'Search...',
              leading: const Icon(Icons.search),
              constraints: const BoxConstraints(
                minWidth: 350, // Minimum width of searchbar
                minHeight: 42, // Minimum height of searchbar
                maxWidth: 350, // Maximum width of searchbar
                maxHeight: 42, // Maximum height of searchbar
              ),
              elevation: MaterialStateProperty.all(0),
            )
          ],
        ),
      );
}
