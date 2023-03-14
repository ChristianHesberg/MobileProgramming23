import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/geocode.dart';


const geoCodingUrl = 'https://geocoding-api.open-meteo.com/v1/search';

class GeoCodeRepository {
  Future<List<GeoCode>> getGeoCodes(String name) async {
    if (name.length < 2) return [];
    final url =
        Uri.parse(geoCodingUrl).replace(queryParameters: {'name': name});
    final response = await http.get(url);
    final data = json.decode(response.body);
    final results = data['results'] as List<dynamic>;
    return results.map((e) => GeoCode.fromJson(e)).toList();
  }
}
