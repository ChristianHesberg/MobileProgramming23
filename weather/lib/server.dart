import 'dart:ffi';
import 'models.dart';

const String baseAssetURL =
    'https://dartpad-workshops-io2021.web.app/getting_started_with_slivers/assets';
const String headerImage = '${baseAssetURL}/header.jpeg';

class Server{
  static List<DailyForecast> getDailyForecast(){
    final daily = _dailyForecast['daily'] as Map<String, Object>;
    final times = daily['time'] as List<String>;
    final weatherCodes = daily['weathercode'] as List<int>;
    final temperature_2m_max = daily['temperature_2m_max'] as List<double>;
    final temperature_2m_min = daily['temperature_2m_min'] as List<double>;

    return List.generate(times.length, (index) => DailyForecast(
        time: DateTime.parse(times[index]),
        weathercode: WeatherCode.fromNumeric(weatherCodes[index]),
        temperature_2m_max: temperature_2m_max[index],
        temperature_2m_min: temperature_2m_min[index]));
  }
}

final _dailyForecast = {
  "latitude": 55.470795,
  "longitude": 8.449936,
  "generationtime_ms": 0.8150339126586914,
  "utc_offset_seconds": 3600,
  "timezone": "Europe/Copenhagen",
  "timezone_abbreviation": "CET",
  "elevation": 16.0,
  "daily_units": {
    "time": "iso8601",
    "weathercode": "wmo code",
    "temperature_2m_max": "°C",
    "temperature_2m_min": "°C"
  },
  "daily": {
    "time": <String>[
      "2023-02-28",
      "2023-03-01",
      "2023-03-02",
      "2023-03-03",
      "2023-03-04",
      "2023-03-05",
      "2023-03-06"
    ],
    "weathercode": <int>[3, 3, 3, 3, 3, 85, 85],
    "temperature_2m_max": <double>[6.8, 5.8, 5.6, 9.1, 5.8, 4.5, 3.9],
    "temperature_2m_min": <double>[-0.2, 0.7, -1.1, 2.7, 2.4, -1.1, -2.3]
  }
};
