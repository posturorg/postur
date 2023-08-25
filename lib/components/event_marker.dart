import 'package:auth_test/components/modals/event_details_modal.dart';
import 'package:auth_test/src/colors.dart';
import 'package:auth_test/src/pin_svg_strings.dart';
import 'package:auth_test/src/user_info_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EventMarker extends StatefulWidget {
  final bool isAttending;
  final String eventTitle;
  final String eventId;
  final String creator;
  final bool isCreator;
  final void Function() reloader;
  const EventMarker({
    super.key,
    required this.isAttending,
    required this.eventTitle,
    required this.eventId,
    required this.creator,
    required this.isCreator,
    required this.reloader,
  });

  @override
  State<EventMarker> createState() => _EventMarkerState();
}

class _EventMarkerState extends State<EventMarker> {
  bool wasError = false;
  late Future<String> profilePicUrl;
  final Widget defaultAvatar = const CircleAvatar(
    backgroundImage: AssetImage('lib/assets/thumbtack.png'),
    radius: 15,
  );

  @override
  void initState() {
    profilePicUrl = getProfilePicUrl(
      widget.creator,
      () {
        setState(() {
          wasError = true; //hopefully this works
        });
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = widget.isAttending ? attendingOrange : absentRed;
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
              eventId: widget.eventId,
              eventTitle: widget.eventTitle,
              creator: widget.creator,
              isCreator: widget.isCreator,
              isAttending: widget.isAttending,
              reloader: widget.reloader,
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
                widget.isAttending ? orangePinStringSVG : redPinStringSVG,
                width: 44.5, //feel free to change this
                height: 44.5, //feel free to change this
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                //TODO: Make more concise
                child: FutureBuilder(
                  //you can probably make this more consise
                  future: profilePicUrl,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      print('snapshot had error!');
                      return defaultAvatar;
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (wasError) {
                        return defaultAvatar;
                      } else {
                        return CircleAvatar(
                          backgroundImage: NetworkImage(snapshot.data!),
                          radius: 15,
                        );
                      }
                    } else {
                      return defaultAvatar;
                    }
                  },
                ),
              )
            ],
          ),
          Text(
            textAlign: TextAlign.center,
            widget.eventTitle,
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
