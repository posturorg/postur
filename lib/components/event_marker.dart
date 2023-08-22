import 'package:auth_test/components/modals/event_details_modal.dart';
import 'package:auth_test/src/colors.dart';
import 'package:auth_test/src/pin_svg_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EventMarker extends StatelessWidget {
  final bool isAttending;
  final String eventTitle;
  final String eventId;
  final String creator;
  final bool isCreator;
  const EventMarker({
    super.key,
    required this.isAttending,
    required this.eventTitle,
    required this.eventId,
    required this.creator,
    required this.isCreator,
  });

  @override
  Widget build(BuildContext context) {
    Color primaryColor = isAttending ? attendingOrange : absentRed;
    print('Marker build');
    return GestureDetector(
      onTap: () {
        //THIS FUNCTION SHOWS THE MODAL
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
            return EventDetailsModal(
              //Change this if you made it...
              eventId: eventId,
              eventTitle: eventTitle,
              creator: creator,
              isCreator: isCreator,
              isAttending: isAttending,
            );
          },
        );
      },
      child: Column(
        children: [
          Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              SvgPicture.string(
                isAttending ? orangePinStringSVG : redPinStringSVG,
                width: 44.5, //feel free to change this
                height: 44.5, //feel free to change this
              ),
              const Icon(
                Icons.circle,
                size: 35,
                color: Colors.black,
              ),
            ],
          ),
          Text(
            textAlign: TextAlign.center,
            eventTitle,
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 14, //Feel free to change this.
            ),
          ),
        ],
      ),
    );
  }
}

// onTap: () {
//                           //THIS FUNCTION SHOWS THE MODAL
//                           showModalBottomSheet<void>(
//                             // context and builder are
//                             // required properties in this widget
//                             context: context,
//                             isScrollControlled: true,
//                             elevation: 0.0,
//                             backgroundColor: Colors.white,
//                             clipBehavior: Clip.antiAlias,
//                             showDragHandle: true,
//                             builder: (BuildContext context) {
//                               //Marker details MODAL START (IT IS THE SIZED BOX)
//                               return EventDetailsModal(
//                                 //Change this if you made it...
//                                 eventId: event['eventId'],
//                                 eventTitle: event['eventTitle'],
//                                 creator: event['creator'],
//                                 isCreator: eventIdToIsCreator[event.id],
//                                 isAttending:
//                                     eventIdToIsAttendingMap[event.id],
//                               );
//                             },
//                           );
//                         },