import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'daily_forecast.dart';
import 'geocode.dart';
import 'hourly_forecast.dart';
import '../utils/shared_preferences_extension.dart';

class AppState extends ChangeNotifier {
  static const forecastKey = 'forecast';
  static const timestampKey = 'timestamp';
  static const useLocationServiceKey = 'useLocationService';
  static const locationKey = 'location';

  List<DailyForecast>? _dailyForecast;
  List<HourlyForecast>? _hourlyForecast;
  DateTime? _timestamp;
  GeoCode? _location;

  Future<bool> setForecast(Map<String, dynamic> forecast) async {
    final prefs = await SharedPreferences.getInstance();
    var success = true;
    success &= await prefs.setDateTime(timestampKey, DateTime.now());
    success &= await prefs.setJson(forecastKey, forecast);
    notifyListeners();
    return success;
  }

  Future<bool> setLocation(GeoCode location) async {
    _location = location;
    final prefs = await SharedPreferences.getInstance();
    final success = await prefs.setJson(locationKey, location);
    notifyListeners();
    return success;
  }

  Future<bool> clearLocation() async {
    _location = null;
    final prefs = await SharedPreferences.getInstance();
    final success = await prefs.remove(locationKey);
    notifyListeners();
    return success;
  }

  UnmodifiableListView<DailyForecast> get dailyForecast =>
      UnmodifiableListView(_dailyForecast ?? []);

  UnmodifiableListView<HourlyForecast> get hourlyForecast =>
      UnmodifiableListView(_hourlyForecast ?? []);

  GeoCode? get location {
    return _location;
  }

  DateTime? get timestamp => _timestamp;

  restore() async {
    final prefs = await SharedPreferences.getInstance();
    final location = prefs.getJson(locationKey);
    if (location != null) _location = GeoCode.fromJson(location);
    _timestamp = prefs.getDateTime(timestampKey);
    final forecast = prefs.getJson(forecastKey);
    if (forecast != null) {
      final daily = forecast?['daily'] as Map<String, dynamic>;
      _dailyForecast = DailyForecast.fromJson(daily);
      final hourly = forecast?['hourly'] as Map<String, dynamic>;
      _hourlyForecast = HourlyForecast.fromJson(hourly);
    }
    notifyListeners();
  }

  isStale() {
    return _timestamp == null ||
        _timestamp!.isBefore(DateTime.now().subtract(const Duration(days: 1)));
  }
}
