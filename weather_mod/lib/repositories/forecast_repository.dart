import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather/models/daily_forecast.dart';
import 'package:weather/models/hourly_forecast.dart';
import 'package:weather/utils/url.dart';

const baseForecastUrl = 'https://api.open-meteo.com/v1/forecast';

class ForecastRepository {
  Future<dynamic> getForecast(
      {required double latitude, required double longitude}) async {
    final url = Uri.parse(baseForecastUrl).replace(
      query: {
        'windspeed_unit': 'ms',
        'timezone': 'auto',
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'hourly': HourlyForecast.fields.join(','),
        'daily': DailyForecast.fields.join(','),
      }.asQueryParameter(),
    );
    print(url);
    final response = await http.get(url);
    final data = json.decode(response.body) as Map<String, dynamic>;
    return data;
  }
}
