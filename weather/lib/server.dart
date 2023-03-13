import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';

const String baseAssetURL =
    'https://dartpad-workshops-io2021.web.app/getting_started_with_slivers/assets';
const String headerImage = '${baseAssetURL}/header.jpeg';

const String baseForecastUrl =
    'https://api.open-meteo.com/v1/forecast?hourly=temperature_2m,apparent_temperature,precipitation_probability,precipitation&daily=weathercode,temperature_2m_max,temperature_2m_min&windspeed_unit=ms&timezone=auto';

class Server {
  static Map<String, dynamic>? _data;

  static restore() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = await prefs.getString('forecast');
    if (jsonString == null) return;
    _data = json.decode(jsonString);
  }

  static save() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(_data);
    await prefs.setString('forecast', jsonString);
  }

  static refresh() async {
    final position = await _determinePosition();
    final url =
        '$baseForecastUrl&latitude=${position.latitude}&longitude=${position.longitude}';
    print(url);
    final response = await http.get(Uri.parse(url));
    final jsonString = response.body;
    _data = json.decode(jsonString);
  }

  static List<DailyForecast> getDailyForecast() {
    if (_data == null) return [];
    final daily = _data!['daily'] as Map<String, dynamic>;
    return DailyForecast.fromJson(daily);
  }

  static List<HourlyForecast> getHourlyForecast() {
    if (_data == null) return [];
    final hourly = _data!['hourly'] as Map<String, dynamic>;
    return HourlyForecast.fromJson(hourly);
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  static Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
