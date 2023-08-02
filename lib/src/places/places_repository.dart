import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

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
  final String key = 'AIzaSyDGT20OxGoAgAv-GuzqIdPN533xcl0dOOU';
  final String types = 'address';

  Future<List<PlaceAutoComplete>?> getAutoComplete(String? input) async {
    final String url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&components=country:us&language=en&location=42.3732%2C-71.1202&radius=50000&types=address&key=$key";
    try {
      var response = await http.get(Uri.parse(url));
      //fix this in the case of no internet... should just do nothijg
      var json = convert.jsonDecode(response.body);
      var status = json['status'];

      if (status == 'OK') {
        var results = json['predictions'] as List;
        return results
            .map((place) => PlaceAutoComplete.fromJson(place))
            .toList();
      } else {
        print(status);
        return [];
      }
    } catch (e) {
      print('Error fetching search results: $e');
      return [];
    }
  }
}
/*
Future<void> getAutoCompleteTest(String input) async {
  //only for testing
  final String url =
      "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&components=country:us&language=en&location=42.3732%2C-71.1202&radius=50000&types=address&key=AIzaSyDGT20OxGoAgAv-GuzqIdPN533xcl0dOOU";

  var response = await http.get(Uri.parse(url));
  var json = convert.jsonDecode(response.body);
  var status = json['status'];

  if (input == '' || input == null) {
    print('no Input!!!');
  }

  if (status == 'OK') {
    var results = json['predictions'] as List;
    print(status);
    print(results.map((place) => place['description']).toList());
  } else {
    print(status);
  }
}
*/