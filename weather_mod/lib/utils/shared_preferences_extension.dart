import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

extension SharedPreferencesExtension on SharedPreferences {
  getDateTime(String key) {
    final timestamp = getString(key);
    return timestamp == null ? null : DateTime.parse(timestamp);
  }

  Future<bool> setDateTime(String key, DateTime value) {
    return setString(key, value.toIso8601String());
  }

  getJson(String key) {
    final jsonString = getString(key);
    if (jsonString == null) return null;
    return json.decode(jsonString);
  }

  Future<bool> setJson(String key, dynamic value) {
    return setString(key, json.encode(value));
  }
}