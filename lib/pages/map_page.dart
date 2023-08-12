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

  // Retrieve current user document
  DocumentReference currentUser = FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid);

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
    //CREATE EVENT MODAL
    //UI PROBLEM, NEED TO FIX WHAT HAPPENS WHEN A KEYBOARD IS PULLED UP
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
        // we set up a container inside which
        // we create center column and display text

        // Returning SizedBox instead of a Container
        return EventCreateModal(
          exists: false,
          /* TODO: Need to edit initialSelectedPlace so that all new events don't end up in Kyrgyzstan */
          /* TODO: NOTE FOR BEN: Right now we have longitude in degrees WEST, Firestore stores them in degrees EAST, so*/
          /* TODO: we have to multiply longitude by -1 somewhere to stay out of Kyrgyzstan*/
          initialSelectedPlace: PlaceAutoComplete(
            'Harvard Square, Brattle Street, Cambridge, MA, USA',
            'ChIJecplvEJ344kRdjumhjIYylk',
          ),
          initialCoords: const LatLng(42.3730,
              71.1209), //Should be obtained from the coordinates of the place clicked
        ); //Need to fix this...
      },
    );
  }

  void _onMapHold(LatLng location) {
    setState(() {
      _showCreateModal(location);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    // Stream current user data to get list of events you're invitd to
    return StreamBuilder<DocumentSnapshot>(
      stream: currentUser.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show Waiting Indicator
          return const Center(child: CircularProgressIndicator(color: absentRed,));
  
        // What to show if data has been received
        } else if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
          // Potenital error message
          if (snapshot.hasError) {
            return const Center(child: Text("Error Occured"));
          // Success
          } else if (snapshot.hasData) {
            // Save sets of events user is either invited to or attending (every element in attending should be inside of invited)
            Set<String> invitedEventIds = Set.from(snapshot.data!['invited'] ?? []);
            Set<String> attendingEventIds = Set.from(snapshot.data!['attending'] ?? []);

            return StreamBuilder<QuerySnapshot>(
              stream: events.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Show Waiting Indicator
                  return const Center(child: CircularProgressIndicator(color: absentRed,));
          
                // What to show if data has been received
                } else if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
                  // Potenital error message
                  if (snapshot.hasError) {
                    return const Center(child: Text("Error Occured"));
                  // Success
                  } else if (snapshot.hasData) {
                    // 
                    Set<Marker> markers = snapshot.data!.docs
                    .where((event) => invitedEventIds.contains(event.id) || attendingEventIds.contains(event.id))
                    .map((event) {
                      // Retrieve GeoPoint location from backend
                      GeoPoint location = event['where'] as GeoPoint;
                      // Convert to LatLng
                      LatLng position = LatLng(location.latitude, location.longitude);
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
                                eventTitle: event['eventTitle'],
                                creator: event['creator'],
                                isCreator: event['creator'] == uid ? true : false,
                                isMember: attendingEventIds.contains(event.id),
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
                        target: _center,
                        zoom: 15.0,
                      ),
                      markers: markers,
                    );
                  }
                }
                return const Center(child: Text("No Data Received"));
              }
            );
          }
        }
        return const Center(child: Text("No Data Received"));
      }
    );
  }
}

