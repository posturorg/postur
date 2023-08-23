import '../components/my_searchbar.dart';
import '../src/colors.dart';
import 'package:flutter/material.dart';
import '../components/chat_widget.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  BoxDecoration searchBarDecoration() {
    return const BoxDecoration(
      border: Border(
          bottom: BorderSide(
        color: backgroundWhite,
        width: 1.0,
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: searchBarDecoration(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MySearchBar(
                searchController: TextEditingController(), //should be
                //instantiated in the widget itself so it can be accessed
                //later
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(children: [
            Column(children: [
              ChatWidget(
                chatTitle: 'Taco Tuesday',
              ),
            ]),
          ]),
        ),
      ],
    );
  }
}
