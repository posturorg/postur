import '../components/my_searchbar.dart';
import 'package:flutter/material.dart';
import '../src/colors.dart';
import '../components/tag_widget.dart';

class TagsPage extends StatefulWidget {
  const TagsPage({super.key});

  @override
  State<TagsPage> createState() => _TagsPageState();
}

class _TagsPageState extends State<TagsPage> {
  @override
  Widget build(BuildContext context) {
    BoxDecoration sectionBoxDecoration() {
      return const BoxDecoration(
        border: Border(
            top: BorderSide(
          color: backgroundWhite,
          width: 1.0,
        )),
      );
    }

    Widget yourTags = Container(
        decoration: sectionBoxDecoration(),
        padding: const EdgeInsets.fromLTRB(20, 10, 25, 0),
        child: Row(children: [
          const Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Your Tags:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: attendingOrange,
                      )),
                ]),
          ),
          GestureDetector(
            onTap: () {
              print("Create Tag");
            },
            child: const Icon(
              Icons.add,
              color: attendingOrange,
              size: 35,
            ),
          ),
        ]));

    Widget suggestedTitle = Container(
        decoration: sectionBoxDecoration(),
        padding: const EdgeInsets.fromLTRB(20, 10, 25, 0),
        child: const Row(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Suggested:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: absentRed,
                )),
          ]),
        ]));

    return ListView(
      children: [
        Column(
          children: [
            const MySearchBar(),
            Column(
              children: [
                yourTags,
                const TagWidget(
                  tagTitle: 'Harvard2024',
                  tagCreator: 'Me',
                  isCreator: true,
                  isMember: true,
                ),
                const TagWidget(
                  tagTitle: 'HarvardHeraldry',
                  tagCreator: 'Ben Dupont',
                  isCreator: false,
                  isMember: true,
                ),
                suggestedTitle,
                const TagWidget(
                  tagTitle: 'Yale2024',
                  tagCreator: 'YaleAdmins',
                  isCreator: false,
                  isMember: false,
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
