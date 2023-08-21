import 'package:auth_test/src/places/places_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import '../components/modals/event_create_modal.dart';
import '../components/modals/event_details_modal.dart';
import '../src/colors.dart';
import '../src/map_style_string.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/* Need to make the map 2d for performance improvement*/

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // Retrieve current user's uid
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  // Retrieve current user's "EventMembers" document
  DocumentReference currentUserEvents = FirebaseFirestore.instance
      .collection('EventMembers')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  // Retrieve events to be shown on the map
  final Query events = FirebaseFirestore.instance.collection('Events');

  int uniqueId = 0;
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(42.3732, -71.1202);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.setMapStyle(mapStyleString);
  }

  Future<void> _showCreateModal(LatLng location) async {
    PlaceAutoComplete locationToPlaceAutoComplete =
        await PlacesRepository().getPlaceAutoCompleteFromLatLng(location);
    // ignore: use_build_context_synchronously
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      elevation: 0.0,
      backgroundColor: Colors.white,
      clipBehavior: Clip.antiAlias,
      showDragHandle: true,
      builder: (BuildContext context) {
        return EventCreateModal(
          thoseInvited: {},
          exists: false,
          initialSelectedPlace: locationToPlaceAutoComplete,
          initialCoords:
              location, //Should be obtained from the coordinates of the place clicked
        ); //Need to fix this...
      },
    );
  }

  void _onMapHold(LatLng location) {
    _showCreateModal(location);
  }

  @override
  Widget build(BuildContext context) {
    // Stream current user data to get list of events you're invitd to
    return StreamBuilder<QuerySnapshot>(
      stream: currentUserEvents.collection('MyEvents').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show Waiting Indicator
          return const Center(
              child: CircularProgressIndicator(
            color: absentRed,
          ));

          // What to show if data has been received
        } else if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.done) {
          // Potenital error message
          if (snapshot.hasError) {
            return const Center(child: Text("Error Occured"));
            // Success
          } else if (snapshot.hasData) {
            // Save sets of events user is either invited to or attending (every element in attending should be inside of invited)
            List<QueryDocumentSnapshot> myEventDocs = snapshot.data!.docs;

            // Initialize an empty map matching eventId's to isAttending
            Map<String, bool> eventIdToIsAttendingMap = {};
            // Initialize an empty map matching eventId's to isCreator
            Map<String, bool> eventIdToIsCreator = {};

            // Iterate through myEventDocs and populate the map
            for (var myEventDoc in myEventDocs) {
              // Get the data from the snapshot
              Map<String, dynamic> data =
                  myEventDoc.data() as Map<String, dynamic>;

              // Extract the 'eventId' and 'isAttending' fields
              String eventId = data['eventId'] as String;
              bool isAttending = data['isAttending'] as bool;
              bool isCreator = data['isCreator'] as bool;

              // Add the entry to the map
              eventIdToIsAttendingMap[eventId] = isAttending;
              eventIdToIsCreator[eventId] = isCreator;
            }

            return StreamBuilder<QuerySnapshot>(
                stream: events.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show Waiting Indicator
                    return const Center(
                        child: CircularProgressIndicator(
                      color: absentRed,
                    ));

                    // What to show if data has been received
                  } else if (snapshot.connectionState ==
                          ConnectionState.active ||
                      snapshot.connectionState == ConnectionState.done) {
                    // Potenital error message
                    if (snapshot.hasError) {
                      return const Center(child: Text("Error Occured"));
                      // Success
                    } else if (snapshot.hasData) {
                      //
                      Set<Marker> markers = snapshot.data!.docs
                          .where((event) =>
                              eventIdToIsAttendingMap.containsKey(event.id))
                          .map((event) {
                        // Retrieve GeoPoint location from backend
                        GeoPoint location = event['where'] as GeoPoint;
                        // Convert to LatLng
                        LatLng position =
                            LatLng(location.latitude, location.longitude);
                        // Return each marker
                        return Marker(
                          // Set marker ID equal to eventId
                          markerId: MarkerId(event.id),
                          position: position,
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
                                  eventId: event['eventId'],
                                  eventTitle: event['eventTitle'],
                                  creator: event['creator'],
                                  isCreator: eventIdToIsCreator[event.id],
                                  isAttending:
                                      eventIdToIsAttendingMap[event.id],
                                );
                              },
                            );
                          },
                        );
                      }).toSet();

                      return GoogleMap(
                        myLocationButtonEnabled: true,
                        myLocationEnabled: true,
                        compassEnabled: false,
                        onLongPress: _onMapHold,
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                          //should be user position if user has shared position, else harvard square.
                          target: _center,
                          zoom: 15.0,
                        ),
                        markers: markers,
                      );
                    }
                  }
                  return const Center(child: Text("No Data Received"));
                });
          }
        }
        return const Center(child: Text("No Data Received"));
      },
    );
  }
}
