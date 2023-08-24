import 'package:auth_test/components/dialogs/default_one_option_dialog.dart';
import 'package:auth_test/components/event_marker.dart';
import 'package:auth_test/src/places/places_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import '../components/modals/event_create_modal.dart';
import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong2;
import 'package:url_launcher/url_launcher.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // Retrieve current user's uid
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  // Initialize the map's controller
  late MapController _mapController;

  // Retrieve events to be shown on the map
  final Query events = FirebaseFirestore.instance.collection('Events');

  final latlong2.LatLng _center = latlong2.LatLng(42.3732, -71.1202);

  List<Marker> _markers = [];

  Future<void> fetchEvents() async {
    print('running');
    //need to finish this to get markers to display
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    try {
      // Get a reference to the user's 'MyEvents' subcollection
      CollectionReference eventsCollection =
          FirebaseFirestore.instance.collection('Events');

      // Query the events where there is a document with name equal to current user's uid
      QuerySnapshot attendedEventsSnapshot = await eventsCollection
          .where('Invited.$uid.isAttending', isNotEqualTo: null)
          .get(); //also get where its true...

      // Fetch all documents in the 'MyEvents' subcollection

      // Loop through each document and print eventId and eventTitle
      List<Widget> _internalMarkers = [];
      for (var eventDoc in attendedEventsSnapshot.docs) {
        Map<String, dynamic> eventData =
            eventDoc.data() as Map<String, dynamic>;
        print("Event ID: ${eventDoc.id}");
        print("Event Title: ${eventData['eventTitle']}");
      }
    } catch (e) {
      print("Error fetching events: $e");
      showDialog(
        context: context,
        builder: (context) => DefaultOneOptionDialog(
          title: 'Something went wrong. Please reload your map.',
          buttonText: 'Ok',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      );
      _markers = [];
    }
  }

  Future<void> _showCreateModal(latlong2.LatLng location) async {
    PlaceAutoComplete locationToPlaceAutoComplete =
        await PlacesRepository().getPlaceAutoCompleteFromLatLng2(location);
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
          initialCoords: PlacesRepository().latLng2ToLatLng(
              location), //Should be obtained from the coordinates of the place clicked
        );
      },
    );
  }

  void _onMapHold(latlong2.LatLng location) {
    _showCreateModal(location);
  }

  @override
  void initState() {
    _mapController = MapController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    fetchEvents();
    return FlutterMap(
      //add a button to go to user location
      //show user location
      mapController: _mapController, // Initialize the controller,
      options: MapOptions(
        onLongPress: (tapPosition, point) => {
          _onMapHold(point),
        },
        maxZoom: 18.42, //seems to work well
        center: _center, //ideally this is the user's location.
        zoom: 18,
      ),
      nonRotatedChildren: [
        RichAttributionWidget(
          //update these...
          attributions: [
            //LogoSourceAttribution(image),
            TextSourceAttribution(
              //ensure this is done correctly
              'Mapbox',
              onTap: () =>
                  launchUrl(Uri.parse('https://www.mapbox.com/about/maps/')),
            ),
            TextSourceAttribution(
              'OpenStreetMap',
              onTap: () =>
                  launchUrl(Uri.parse('https://www.openstreetmap.org/about/')),
            ),
            TextSourceAttribution(
              'Improve this map',
              prependCopyright: false,
              onTap: () => launchUrl(Uri.parse(
                  'https://www.mapbox.com/contribute/#/?utm_source=https%3A%2F%2Fdocs.mapbox.com%2F&utm_medium=attribution_link&utm_campaign=referrer&l=10%2F40%2F-74.5&q=')),
            ),
          ],
        ),
      ],
      children: [
        TileLayer(
          urlTemplate:
              'https://api.mapbox.com/styles/v1/posturmain/clllpwx6u02d001qlcplz2u3e/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicG9zdHVybWFpbiIsImEiOiJjbGxscGFmeGkyOGhwM2Rwa2loMDdrMWFjIn0.C5alCHxZEODxaSeGMq9oxA',
          userAgentPackageName: 'com.example.app', //change this...
        ),
        MarkerLayer(
          markers: _markers,
        ),
      ],
    );
    // var TestMap = StreamBuilder<QuerySnapshot>(
    //   stream: currentUserEvents.collection('MyEvents').snapshots(),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       // Show Waiting Indicator
    //       return const Center(
    //         child: CircularProgressIndicator(
    //           color: absentRed,
    //         ),
    //       );

    //       // What to show if data has been received
    //     } else if (snapshot.connectionState == ConnectionState.active ||
    //         snapshot.connectionState == ConnectionState.done) {
    //       // Potenital error message
    //       if (snapshot.hasError) {
    //         return const Center(child: Text("Error Occured"));
    //         // Success
    //       } else if (snapshot.hasData) {
    //         // Save sets of events user is either invited to or attending (every element in attending should be inside of invited)
    //         List<QueryDocumentSnapshot> myEventDocs = snapshot.data!.docs;

    //         // Initialize an empty map matching eventId's to isAttending
    //         Map<String, bool> eventIdToIsAttendingMap = {};
    //         // Initialize an empty map matching eventId's to isCreator
    //         Map<String, bool> eventIdToIsCreator = {};

    //         // Iterate through myEventDocs and populate the map
    //         for (var myEventDoc in myEventDocs) {
    //           // Get the data from the snapshot
    //           Map<String, dynamic> data =
    //               myEventDoc.data() as Map<String, dynamic>;

    //           // Extract the 'eventId' and 'isAttending' fields
    //           String eventId = data['eventId'] as String;
    //           bool isAttending = data['isAttending'] as bool;
    //           bool isCreator = data['isCreator'] as bool;

    //           // Add the entry to the map
    //           eventIdToIsAttendingMap[eventId] = isAttending;
    //           eventIdToIsCreator[eventId] = isCreator;
    //         }

    //         return StreamBuilder<QuerySnapshot>(
    //           stream: events.snapshots(),
    //           builder: (context, snapshot) {
    //             if (snapshot.connectionState == ConnectionState.waiting) {
    //               // Show Waiting Indicator
    //               return const Center(
    //                   child: CircularProgressIndicator(
    //                 color: absentRed,
    //               ));

    //               // What to show if data has been received
    //             } else if (snapshot.connectionState == ConnectionState.active ||
    //                 snapshot.connectionState == ConnectionState.done) {
    //               // Potenital error message
    //               if (snapshot.hasError) {
    //                 return const Center(child: Text("Error Occured"));
    //                 // Success
    //               } else if (snapshot.hasData) {
    //                 // get only markers close to user.
    //                 Set<Marker> markers = snapshot.data!.docs
    //                     .where((event) =>
    //                         eventIdToIsAttendingMap.containsKey(event.id))
    //                     .map((event) {
    //                   // Retrieve GeoPoint location from backend
    //                   GeoPoint location = event['where'] as GeoPoint;
    //                   // Convert to LatLng
    //                   latlong2.LatLng position = latlong2.LatLng(
    //                       location.latitude, location.longitude);
    //                   // Return each marker
    //                   return Marker(
    //                     // Set marker ID equal to eventId
    //                     point: position,
    //                     width: 106,
    //                     height: 106,
    //                     builder: (context) => EventMarker(
    //                       isAttending: eventIdToIsAttendingMap[event.id]!,
    //                       eventId: event['eventId'],
    //                       eventTitle: event['eventTitle'],
    //                       creator: event['creator'],
    //                       isCreator: eventIdToIsCreator[event.id]!,
    //                     ),
    //                   );
    //                 }).toSet();

    //                 return FlutterMap(
    //                   //add a button to go to user location
    //                   //show user location
    //                   mapController:
    //                       _mapController, // Initialize the controller,
    //                   options: MapOptions(
    //                     onLongPress: (tapPosition, point) => {
    //                       _onMapHold(point),
    //                     },
    //                     maxZoom: 18.42, //seems to work well
    //                     center: _center, //ideally this is the user's location.
    //                     zoom: 18,
    //                   ),
    //                   nonRotatedChildren: [
    //                     RichAttributionWidget(
    //                       //update these...
    //                       attributions: [
    //                         //LogoSourceAttribution(image),
    //                         TextSourceAttribution(
    //                           //ensure this is done correctly
    //                           'Mapbox',
    //                           onTap: () => launchUrl(Uri.parse(
    //                               'https://www.mapbox.com/about/maps/')),
    //                         ),
    //                         TextSourceAttribution(
    //                           'OpenStreetMap',
    //                           onTap: () => launchUrl(Uri.parse(
    //                               'https://www.openstreetmap.org/about/')),
    //                         ),
    //                         TextSourceAttribution(
    //                           'Improve this map',
    //                           prependCopyright: false,
    //                           onTap: () => launchUrl(Uri.parse(
    //                               'https://www.mapbox.com/contribute/#/?utm_source=https%3A%2F%2Fdocs.mapbox.com%2F&utm_medium=attribution_link&utm_campaign=referrer&l=10%2F40%2F-74.5&q=')),
    //                         ),
    //                       ],
    //                     ),
    //                   ],
    //                   children: [
    //                     TileLayer(
    //                       urlTemplate:
    //                           'https://api.mapbox.com/styles/v1/posturmain/clllpwx6u02d001qlcplz2u3e/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicG9zdHVybWFpbiIsImEiOiJjbGxscGFmeGkyOGhwM2Rwa2loMDdrMWFjIn0.C5alCHxZEODxaSeGMq9oxA',
    //                       userAgentPackageName:
    //                           'com.example.app', //change this...
    //                     ),
    //                     MarkerLayer(
    //                       markers: markers.toList(),
    //                     ),
    //                   ],
    //                 );

    //                 // GoogleMap(
    //                 //   myLocationButtonEnabled: true,
    //                 //   myLocationEnabled: true,
    //                 //   compassEnabled: false,
    //                 //   onLongPress: _onMapHold,
    //                 //   onMapCreated: _onMapCreated,
    //                 //   initialCameraPosition: CameraPosition(
    //                 //     //should be user position if user has shared position, else harvard square.
    //                 //     target: _center,
    //                 //     zoom: 15.0,
    //                 //   ),
    //                 //   markers: markers,
    //                 // );
    //               }
    //             }
    //             return const Center(child: Text("No Data Received"));
    //           },
    //         );
    //       }
    //     }
    //     return const Center(child: Text("No Data Received"));
    //   },
    // );
  }
}
