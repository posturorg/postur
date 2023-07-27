import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class LocationService {
  final String key = 'AIzaSyDGT20OxGoAgAv-GuzqIdPN533xcl0dOOU';

  Future<List<String>> getEventList(String input) async {
    final String url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?" +
            "input=$input" +
            "&components=country:us" +
            "&language=en" +
            "&location=42.3732%2C-71.1202" + // Harvard Square
            "&radius=50000" + // within 50km of the square
            "&key=$key";

    return [];
  }

  /*Future<String> getPlaceId(String input) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key';

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);

    var placeId = json['candidates'][0]['place_id'] as String;

    //print(placeId);

    return placeId;
  } //Gets place ID

  Future<Map<String, dynamic>> getPlace(String input) async {
    var placeId = await getPlaceId(input);
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var results = json['result'] as Map<String, dynamic>;

    print(results);
    return results;
  } */
}
