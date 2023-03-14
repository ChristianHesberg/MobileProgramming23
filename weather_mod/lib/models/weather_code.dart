// 0 	Clear sky
// 1, 2, 3 	Mainly clear, partly cloudy, and overcast
// 45, 48 	Fog and depositing rime fog
// 51, 53, 55 	Drizzle: Light, moderate, and dense intensity
// 56, 57 	Freezing Drizzle: Light and dense intensity
// 61, 63, 65 	Rain: Slight, moderate and heavy intensity
// 66, 67 	Freezing Rain: Light and heavy intensity
// 71, 73, 75 	Snow fall: Slight, moderate, and heavy intensity
// 77 	Snow grains
// 80, 81, 82 	Rain showers: Slight, moderate, and violent
// 85, 86 	Snow showers slight and heavy
// 95 * 	Thunderstorm: Slight or moderate
// 96, 99 * 	Thunderstorm with slight and heavy hail
enum WeatherCode {
  ClearSky(0, 'Clear sky', 'skc'),

  MainlyClear(1, 'Mainly clear', 'few'),
  PartlyCloudy(2, 'Partly cloudy', 'sct'),
  Overcast(3, 'Overcast', 'ovc'),

  Fog(45, 'Fog', 'fg'),
  DepositingRimeFog(48, 'Depositing rime fog', 'fg'),

  DrizzleLight(51, 'Drizzle: Light intensity', 'minus_ra'),
  DrizzleModerate(53, 'Drizzle: Moderate intensity', 'minus_ra'),
  DrizzleDense(55, 'Drizzle: Dense intensity', 'minus_ra'),

  FreezingDrizzleLight(56, 'Freezing Drizzle: Light intensity', 'fzra'),
  FreezingDrizzleDense(57, 'Freezing Drizzle: dense intensity', 'fzra'),

  RainSlight(61, 'Rain: Slight intensity', 'minus_ra'),
  RainModerate(63, 'Rain: Moderate intensity', 'ra'),
  RainHeavy(65, 'Rain: Heavy intensity', 'ra'),

  FreezingRainLight(66, 'Freezing Rain: Light intensity', 'ra_fzra'),
  FreezingRainHeavy(66, 'Freezing Rain: Heavy intensity', 'ra_fzra'),

  SnowFallSlight(71, 'Snow fall: Slight intensity', 'sn'),
  SnowFallModerate(73, 'Snow fall: Moderate intensity', 'sn'),
  SnowFallHeavy(75, 'Snow fall: Heavy intensity', 'blizzard'),

  SnowGrains(77, 'Snow grains', 'snip'),

  RainShowersSlight(80, 'Rain showers: Slight', 'shra'),
  RainShowersModerate(81, 'Rain showers: Moderate', 'shra'),
  RainShowersVoilent(82, 'Rain showers: Violent', 'shra'),

  SnowShowersSlight(85, 'Snow showers: Slight', 'ip'),
  SnowShowersHeavy(86, 'Snow showers: Heavy', 'raip'),

  Thunerstorm(95, 'Thunderstorm: Slight or moderate', 'scttsra'),
  ThunderstormSlightHail(96, 'Thunderstorm with slight hail', 'tsra'),
  ThunderstormHeavyHail(99, 'Thunderstorm with heavy hail', 'tsra'),
  ;

  final int numeric;
  final String description;
  final String icon;
  const WeatherCode(this.numeric, this.description, this.icon);

  get imageAsset {
    return 'assets/${icon}.png';
  }

  static final _map =
      Map.fromEntries(WeatherCode.values.map((e) => MapEntry(e.numeric, e)));
  factory WeatherCode.fromNumeric(int numeric) {
    return WeatherCode._map[numeric]!;
  }
}
