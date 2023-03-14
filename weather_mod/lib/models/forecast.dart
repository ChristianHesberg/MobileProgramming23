import 'package:weather/models/daily_forecast.dart';
import 'package:weather/models/hourly_forecast.dart';

class Forecast {
  static const dailyKey = 'daily';
  static const hourlyKey = 'hourly';
  final List<DailyForecast> daily;
  final List<HourlyForecast> hourly;

  Forecast({required this.daily, required this.hourly});

  factory Forecast.fromJson(Map<String, dynamic> json) {
    final daily =
        DailyForecast.fromJson(json[dailyKey] as Map<String, dynamic>);
    final hourly =
        HourlyForecast.fromJson(json[hourlyKey] as Map<String, dynamic>);
    return Forecast(daily: daily, hourly: hourly);
  }
}
