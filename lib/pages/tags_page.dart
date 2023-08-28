import 'package:auth_test/components/modals/create_tag_modal.dart';
import 'package:auth_test/components/your_tags.dart';
import 'package:flutter/material.dart';
import '../src/colors.dart';
import '../components/my_searchbar.dart';

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
          ),
        ),
      );
    }

    Widget yourTagsTitle = Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 25, 0),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Tags:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: attendingOrange,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              print("Create Tag");
            },
            child: IconButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  // context and builder are
                  // required properties in this widget
                  context: context,
                  isScrollControlled: true,
                  elevation: 0.0,
                  backgroundColor: Colors.white,
                  clipBehavior: Clip.antiAlias,
                  showDragHandle: true,
                  builder: (BuildContext context) {
                    //Marker details MODAL START (IT IS THE SIZED BOX)
                    return const CreateTagModal(
                      tagId: null,
                      exists: false,
                      thoseInvited: {},
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.add,
                color: attendingOrange,
                size: 35,
              ),
            ),
          ),
        ],
      ),
    );

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

    return Column(
      children: [
        MySearchBar(
          searchController: TextEditingController(), //should make this an
          //object initialized in the widget instead.
        ),
        const Divider(
          color: backgroundWhite,
          thickness: 1.0,
        ),
        Expanded(
          child: ListView(
            children: [
              Column(
                children: [
                  yourTagsTitle,
                  const YourTags(isMember: true),
                  suggestedTitle,
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
