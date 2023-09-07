import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:latlong2/latlong.dart' as latlong2;

class PlaceAutoComplete {
  final String address;
  final String placeId;

  PlaceAutoComplete(this.address, this.placeId);

  static PlaceAutoComplete fromJson(dynamic json) {
    final String address = json['description'];
    final String placeId = json['place_id'];
    return PlaceAutoComplete(address, placeId);
  }
}

class PlacesRepository {
  final String key = 'p9aZcoiM2tdUAi6sNmo0f1m_fwS5l7hQTilUO8EasUg';

  Future<LatLng?> getCoordsFromPlaceId(String placeId) async {
    //seems to be done
    final String url =
        'https://lookup.search.hereapi.com/v1/lookup?id=$placeId&apiKey=$key';
    try {
      var response = await http.get(Uri.parse(url));
      //print(response.body);
      var json = convert.jsonDecode(response.body);
      var resultsString = json['position'].toString();
      var resultsJson = convert.jsonDecode(resultsString);
      String latString = resultsJson['lat'];
      String lngString = resultsJson['lng'];
      double lat = double.parse(latString);
      double lng = double.parse(lngString);

      return LatLng(lat, lng);
    } catch (e) {
      print('ERROR IN getCoordsFromPlaceId');
      print(e.toString());
      return null;
    }
  }

  Future<List<PlaceAutoComplete>?> getAutoComplete(String? input) async {
    final String url =
        "https://autosuggest.search.hereapi.com/v1/autosuggest?at=42.3732,-71.1202&limit=5&lang=en&q=$input&apiKey=$key"; //must update at according to users location once expanded out of Harvard
    try {
      var response = await http.get(Uri.parse(url));
      var json = convert.jsonDecode(response.body);
      var items = json['items'] as List<dynamic>;
      // Create a list of PlaceAutoComplete objects from the "items" list
      List<PlaceAutoComplete> autoCompleteList = items.map((item) {
        //error might be here. May need to again parse 'item' with convert.jsonDecode
        String title = item['title'];
        String id = item['id'];
        return PlaceAutoComplete(title, id);
      }).toList();
      return autoCompleteList;
    } catch (e) {
      print('ERROR IN getAutoComplete');
      print('Error fetching search results: $e');
      return [];
    }
  }

  Future<PlaceAutoComplete> getPlaceAutoCompleteFromLatLng(
      LatLng pointClicked) async {
    final String lat = pointClicked.latitude.toString();
    final String lng = pointClicked.longitude.toString();
    final String url =
        'https://revgeocode.search.hereapi.com/v1/revgeocode?at=$lat%2C$lng&lang=en-US&apiKey=$key';
    try {
      var response = await http.get(Uri.parse(url));
      Map<String, dynamic> jsonMap = convert.jsonDecode(response.body);
      String formattedAddress = jsonMap['items'][0]['title'] as String;
      String placeId = jsonMap['items'][0]['id'] as String;
      return PlaceAutoComplete(formattedAddress, placeId);
    } catch (e) {
      print('ERROR IN getPlaceAutoCompleteFromLatLng');
      print(e.toString());
      return PlaceAutoComplete('Error getting location...', 'Null');
    }
  }

  Future<PlaceAutoComplete> getPlaceAutoCompleteFromLatLng2(
      //Working on this...
      latlong2.LatLng pointClicked) async {
    final correctedPoint = latLng2ToLatLng(pointClicked);
    return getPlaceAutoCompleteFromLatLng(correctedPoint);
  }

  LatLng latLng2ToLatLng(latlong2.LatLng coords) {
    double latitude = coords.latitude;
    double longitude = coords.longitude;
    return LatLng(latitude, longitude);
  }

  latlong2.LatLng latLngToLatLng2(LatLng coords) {
    double latitude = coords.latitude;
    double longitude = coords.longitude;
    return latlong2.LatLng(latitude, longitude);
  }
}
