import 'dart:async';
import 'package:auth_test/components/modals/create_tag_modal.dart';
import 'package:auth_test/components/tag_widget.dart';
import 'package:auth_test/components/your_tags.dart';
import 'package:auth_test/src/search_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../src/colors.dart';
import '../components/my_searchbar.dart';

class TagsPage extends StatefulWidget {
  const TagsPage({super.key});

  @override
  State<TagsPage> createState() => _TagsPageState();
}

class _TagsPageState extends State<TagsPage> {
  late String searchText;
  TextEditingController searchController = TextEditingController();
  late Stream<QuerySnapshot<Object?>> tagsStream;
  Timer? debounceSearch;
  late void Function(String queryText) onSearchChange;
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  late Stream usersTagMembersStream;

  @override
  void initState() {
    usersTagMembersStream = FirebaseFirestore.instance
        .collection('TagMembers')
        .doc(uid)
        .collection('MyTags')
        .snapshots();
    searchText = '';
    super.initState();
    tagsStream =
        FirebaseFirestore.instance.collection('Tags').limit(40).snapshots();
    onSearchChange = (queryText) {
      //strip initial # from searchText
      //declaring onSearchChange
      if (debounceSearch?.isActive ?? false) debounceSearch?.cancel();
      debounceSearch = Timer(const Duration(milliseconds: 500), () {
        queryText.trim(); //maybe should be outside of debouncing
        if (queryText.isNotEmpty) {
          if (queryText[0] == '#') {
            queryText = queryText.substring(1).trim();
          }
        }
        if (searchText != queryText) {
          setState(() {
            tagsStream = streamTagsWithMatchingTagTitle(queryText);
            searchText = queryText;
          });
        }
      });
    };
  }

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
          searchController: searchController,
          onChanged: onSearchChange,
        ),
        const Divider(
          color: backgroundWhite,
          thickness: 1.0,
        ),
        StreamBuilder(
          stream: tagsStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error.toString()}; layer 1');
            }
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  color: absentRed,
                ),
              ); // Loading indicator
            }
            final tagsDocs = snapshot.data!.docs;
            List<Map<String, dynamic>> tagsList = tagsDocs
                .map((tagDoc) => tagDoc.data() as Map<String, dynamic>)
                .toList();
            print(tagsList);
            return StreamBuilder(
              stream: usersTagMembersStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error.toString()}; layer 2');
                }
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: absentRed,
                    ),
                  ); // Loading indicator
                }
                Set usersMemberTags = snapshot.data!.docs
                    .map((doc) => doc.data()['tagId']
                        as String?) // Assuming the title is stored in a field named "tagId"
                    .toSet(); // Convert to a Set
                return Expanded(
                  child: ListView.builder(
                    itemCount: 3 + tagsList.length,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Visibility(
                          visible: searchText == '',
                          child: yourTagsTitle,
                        );
                      } else if (index == 1) {
                        return Visibility(
                          visible: searchText == '',
                          child: const YourTags(isMember: true),
                        ); //might want to fix this so not all calls of your tags need to be done upon viewing
                      } else if (index == 2) {
                        return Visibility(
                          visible: searchText == '',
                          child: suggestedTitle,
                        );
                      } else {
                        Map<String, dynamic> relevantTag = tagsList[index - 3];
                        //TODO: This, when you get a chance
                        // Here is where we display tags you are searching for...
                        // if searchText == '', only show tags you're not a member of.
                        // Otherwise, show all tags that meet the search criteria
                        // here is where we return our items.
                        return Visibility(
                          visible: true,
                          child: TagWidget(
                            //need to add onJoin
                            tagId: relevantTag['tagId'],
                            tagCreator: relevantTag['creator'],
                            isMember:
                                !usersMemberTags.contains(relevantTag['tagId']),
                            //usersMemberTags.contains(relevantTag[
                            //'tagId']), //need to do some fetching for this
                            isCreator: uid == relevantTag['creator'],
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
