import 'package:auth_test/src/create_event_marker.dart';

import '../components/modals/event_create_modal.dart';
import '../components/modals/event_details_modal.dart';
import '../src/map_style_string.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/* Need to make the map 2d for performance improvement*/

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  int uniqueId = 0;
  late GoogleMapController mapController;
  Set<Marker> _markers = {};
  final LatLng _center = const LatLng(42.3732, -71.1202);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.setMapStyle(mapStyleString);
  }

  Future<void> _addMarker(LatLng location) async {
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
        return const EventCreateModal(exists: false); //Need to fix this...
      },
    );

    final icon = await createEventMarker(context, 'Hello', true);

    final markerId = MarkerId(uniqueId.toString());
    final marker = Marker(
      markerId: markerId,
      position: location,
      icon: icon,
      /*infoWindow: InfoWindow(
        title: 'Tapped Location',
        snippet: 'Latitude: ${location.latitude}, Longitude: ${location.longitude}',
      ),*/
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
            return const EventDetailsModal(
              //Change this if you made it...
              eventTitle: 'eventTitle',
              eventCreator: 'eventCreator',
              isCreator: true,
              isMember: true,
            );
          },
        );
      },
    );
    uniqueId++;

    setState(() {
      _markers.add(marker);
    });
  }

  void _onMapHold(LatLng location) {
    setState(() {
      _addMarker(location);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: GoogleMap(
        myLocationButtonEnabled: false,
        myLocationEnabled: true,
        compassEnabled: false,
        onLongPress: _onMapHold,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 15.0,
        ),
        markers: _markers,
        //Check below suggestion. Implement later.
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
          Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
        ].toSet(),
      ),
    );
  }
}
