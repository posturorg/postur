import 'package:auth_test/components/modal_bottom_button.dart';

import '../../src/colors.dart';
import '../tag_box_decoration.dart';
import 'package:flutter/material.dart';

class TagModal extends StatelessWidget {
  final String tagTitle;
  final bool isCreator;
  final String tagCreator;
  final bool isMember;
  final Function()? onJoin;
  final Function()? onLeave;

  const TagModal({
    super.key,
    required this.tagTitle,
    required this.isCreator,
    required this.tagCreator,
    required this.isMember,
    required this.onJoin,
    required this.onLeave,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 700,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Icon(
              Icons.circle,
              size: 85,
            ),
            Text(
              '#$tagTitle',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isMember ? attendingOrange : absentRed,
              ),
            ),
            Container(
              decoration: tagBoxDecoration(),
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Creator: ${isCreator ? 'Me' : tagCreator}',
                      style: const TextStyle(
                        fontSize: 17,
                      )),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context)
                            .style, // Use the default text style from the context
                        children: const [
                          TextSpan(
                            text: 'Description: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          TextSpan(
                            text:
                                'Never gonna give you up, never gonna let you down, never gonna run around and desert you!',
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context)
                            .style, // Use the default text style from the context
                        children: const [
                          TextSpan(
                            text: 'Members: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          TextSpan(
                            text:
                                'Never gonna make you cry, never gonna say goodbye, never gonna tell a lie and hurt you!',
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Visibility(
                        visible: isCreator,
                        //This is the edit button:
                        child: ModalBottomButton(
                          onTap: () {},
                          text: 'Edit',
                          backgroundColor: neutralGrey,
                        )),
                    ModalBottomButton(
                        onTap: isMember
                            ? onLeave
                            : onJoin, //Replace this with notification if isMember, else nothing
                        text: isMember ? 'Leave' : 'Join',
                        backgroundColor:
                            isMember ? attendingOrange : absentRed),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
