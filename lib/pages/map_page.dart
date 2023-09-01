import 'package:auth_test/components/event_marker.dart';
import 'package:auth_test/src/places/places_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
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
  late void Function() standardReloader;

  // Retrieve current user's uid
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  // Initialize the map's controller
  late MapController _mapController;

  // Retrieve events to be shown on the map
  final Query events = FirebaseFirestore.instance.collection('Events');

  final latlong2.LatLng _center = const latlong2.LatLng(42.3732, -71.1202);

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
          tagsInvited: {},
          reloader: standardReloader,
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

  Future<List<Map<String, dynamic>>> fetchEventData() async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    CollectionReference eventsCollection =
        FirebaseFirestore.instance.collection('Events');

    QuerySnapshot eventSnapshot =
        await eventsCollection.where('Invited.$uid', isNotEqualTo: null).get();

    List<Map<String, dynamic>> eventDataList = eventSnapshot.docs
        .map((eventDoc) => eventDoc.data() as Map<String, dynamic>)
        .toList();

    return eventDataList;
  }

  Future<Map<String, Map<String, dynamic>>> fetchMyEvents() async {
    final String uid =
        FirebaseAuth.instance.currentUser!.uid; //may be unnecessary
    //this might be a costly method

    // Straightforeward, eventMembersCollection
    CollectionReference eventMembersCollection =
        FirebaseFirestore.instance.collection('EventMembers');

    // Events you are attending, stored within the EventMembers collection

    CollectionReference myEventsSubcollection =
        eventMembersCollection.doc(uid).collection('MyEvents');

    QuerySnapshot myEventsQuery = await myEventsSubcollection.get();
    List<QueryDocumentSnapshot<Object?>> myEventsListOfDocs =
        myEventsQuery.docs;

    Map<String, Map<String, dynamic>> myEventsMap = {};

    for (QueryDocumentSnapshot<Object?> event in myEventsListOfDocs) {
      Map<String, dynamic> eventMap = event.data() as Map<String, dynamic>;
      String eventId = eventMap['eventId'];
      myEventsMap[eventId] = eventMap;
    }

    return myEventsMap;
  }

  late Future<List<Map<String, dynamic>>> eventDataList;
  late Future<Map<String, Map<String, dynamic>>> myEventsMap;

  @override
  void initState() {
    _mapController = MapController();
    super.initState();
    eventDataList = fetchEventData(); //must re set this on set state...
    myEventsMap = fetchMyEvents(); //must re set this on set state...
    standardReloader = () async {
      //add loading circle here.
      Future.delayed(
        const Duration(milliseconds: 250),
        () {
          setState(() {
            eventDataList = fetchEventData(); //must re set this on set state...
            myEventsMap = fetchMyEvents();
          });
        },
      );
    };
  }

  Widget myMap(List<Marker> markers) {
    return FlutterMap(
      //add a button to go to user location
      //show user location
      mapController: _mapController, // Initialize the controller,
      options: MapOptions(
        interactiveFlags:
            InteractiveFlag.all & ~InteractiveFlag.rotate, // Disable rotation
        onLongPress: (tapPosition, point) => {
          _onMapHold(point), //TODO: Speed this up
        },
        maxZoom: 18.42, //seems to work well
        center: _center, //ideally this is the user's location.
        zoom: 18,
      ),
      nonRotatedChildren: [
        RichAttributionWidget(
          //TODO: Remove flutter map attribution
          //TODO: DO ATTRIBUTION
          //update these...
          attributions: [
            const LogoSourceAttribution(
                Image(image: NetworkImage(''))), //mapbox logo goes here
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
        CurrentLocationLayer(
            //need to add https://pub.dev/packages/flutter_compass
            //need to make autofollow and autorotate according to compass heading
            ),
        MarkerLayer(
          markers: markers,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([eventDataList, myEventsMap]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return myMap([]);
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error: ${snapshot.error}",
            ),
          ); //maybe style this, lol
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return myMap([]);
        } else {
          // Cast snapshot.data to the correct type
          List<Object?> dataList = snapshot.data as List<Object?>;

          // Assuming dataList[0] is a List<Map<String, dynamic>>
          List<Map<String, dynamic>> eventDataListInternal =
              dataList[0] as List<Map<String, dynamic>>;

          // Assuming dataList[1] is a Map<String, dynamic>
          Map<String, Map<String, dynamic>> eventsMap =
              dataList[1] as Map<String, Map<String, dynamic>>;

          List<Marker> markers = [];

          for (var eventData in eventDataListInternal) {
            try {
              //there's some weird error occasionally going on,
              //where eventDataList has an event with an event Id that is not a
              //key in eventsMap... address later, but try loop is a good safety
              //measure.
              String eventId = eventData['eventId'];
              String eventTitle = eventData['eventTitle'];
              bool isAttending = eventsMap[eventId]!['isAttending'];
              String creator = eventData['creator'];
              bool isCreator = eventsMap[eventId]!['isCreator'];
              GeoPoint where = eventData['where'];
              latlong2.LatLng position =
                  latlong2.LatLng(where.latitude, where.longitude);
              Marker markerToBeAdded = Marker(
                rotate: true,
                point: position,
                width: 106,
                height: 106,
                builder: (context) => EventMarker(
                  reloader: standardReloader,
                  isAttending: isAttending,
                  eventId: eventId,
                  eventTitle: eventTitle,
                  creator: creator,
                  isCreator: isCreator,
                ),
              );
              markers.add(markerToBeAdded);
            } catch (e) {
              print(e.toString());
            }
          }

          return myMap(markers);
        }
      },
    );
  }
}
