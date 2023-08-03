import 'package:flutter/material.dart';

import '../src/colors.dart';
import 'map_page.dart';
import 'tags_page.dart';
import 'chats_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var topTextString = 'Postur';

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const MapPage();
        topTextString = 'Postur';
        break;
      case 1:
        page = const TagsPage();
        topTextString = 'Tags';
        break;
      case 2:
        page = const ChatsPage();
        topTextString = 'Chats';
        break;
      case 3:
        page = const ProfilePage();
        topTextString = 'Profile';
        break;
      case 4:
        page = const Placeholder();
        //topTextString = 'Chat';
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    var topText = Text(topTextString,
        style: const TextStyle(
          color: absentRed,
          fontWeight: FontWeight.bold,
        ));

    // The container for the current page, with its background color
    // and subtle switching animation.
    var mainArea = ColoredBox(
      color: /*colorScheme.surfaceVariant,*/ Colors.white,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: page,
      ),
    );

    if (selectedIndex <= 3) {
      return Scaffold(
        appBar: AppBar(
          title: topText,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 450) {
              // Use a more mobile-friendly layout with BottomNavigationBar
              // on narrow screens.
              return Column(
                children: [
                  Expanded(child: mainArea),
                  SafeArea(
                    child: BottomNavigationBar(
                      elevation: 0,
                      type: BottomNavigationBarType.fixed,
                      items: const [
                        BottomNavigationBarItem(
                          icon: Icon(
                            Icons.place_outlined,
                              color: absentRed),
                          activeIcon: Icon(
                            Icons.place,
                            color: absentRed,
                          ),
                          label: '',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(
                            Icons.bookmark_outline,
                            color: absentRed
                          ),
                          activeIcon: Icon(
                            Icons.bookmark,
                            color: absentRed,
                          ),
                          label: '',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(
                            Icons.chat_bubble_outline,
                            color: absentRed,
                          ),
                          activeIcon: Icon(
                            Icons.chat_bubble,
                            color: absentRed,
                          ),
                          label: '',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(
                            Icons.person_outline,
                            color: absentRed,
                          ),
                          activeIcon: Icon(
                            Icons.person,
                            color: absentRed,
                          ),
                          label: '',
                        ),
                      ],
                      currentIndex: selectedIndex,
                      onTap: (value) {
                        setState(() {
                          selectedIndex = value;
                        });
                      },
                    ),
                  )
                ],
              );
            } else {
              return Row(
                children: [
                  SafeArea(
                    child: NavigationRail(
                      //backgroundColor: Color.fromARGB(255, 255, 210, 207),
                      extended: constraints.maxWidth >= 600,
                      destinations: const [
                        NavigationRailDestination(
                          icon: Icon(Icons.place, color: absentRed),
                          label: Text('Map'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.bookmark_border, color: absentRed),
                          label: Text('Tags'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.chat, color: absentRed),
                          label: Text('Chats'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.person, color: absentRed),
                          label: Text('Profile'),
                        ),
                      ],
                      selectedIndex: selectedIndex,
                      onDestinationSelected: (value) {
                        setState(() {
                          selectedIndex = value;
                        });
                      },
                    ),
                  ),
                  Expanded(child: mainArea),
                ],
              );
            }
          },
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: topText,
        ),
        body: page,
      );
    }
  }
}
