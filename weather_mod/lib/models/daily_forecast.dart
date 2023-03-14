import 'weather_code.dart';

class DailyForecast {
  static const timeKey = 'time';
  static const weatherCodeKey = 'weathercode';
  static const temperatureMaxKey = 'temperature_2m_max';
  static const temperatureMinKey = 'temperature_2m_min';

  static const fields = [
    weatherCodeKey,
    temperatureMaxKey,
    temperatureMinKey
  ];

  final DateTime time;
  final WeatherCode weathercode;
  final double temperature_2m_max;
  final double temperature_2m_min;

  DailyForecast(
      {required this.time,
      required this.weathercode,
      required this.temperature_2m_max,
      required this.temperature_2m_min});

  String getWeekday() {
    switch (time.weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return '';
    }
  }

  static List<DailyForecast> fromJson(Map<String, dynamic> daily) {
    final times = daily[timeKey] as List<dynamic>;
    final weathercodes = daily[weatherCodeKey] as List<dynamic>;
    final temperature_2m_max = daily[temperatureMaxKey] as List<dynamic>;
    final temperature_2m_min = daily[temperatureMinKey] as List<dynamic>;
    return List.generate(
        times.length,
        (index) => DailyForecast(
            time: DateTime.parse(times[index]),
            weathercode: WeatherCode.fromNumeric(weathercodes[index]),
            temperature_2m_max: temperature_2m_max[index],
            temperature_2m_min: temperature_2m_min[index]));
  }
}
