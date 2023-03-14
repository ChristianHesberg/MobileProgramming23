class GeoCode {
  static const nameKey = 'name';
  static const countryCodeKey = 'country_code';
  static const latitudeKey = 'latitude';
  static const longitudeKey = 'longitude';

  final String name;
  final String countryCode;
  final double latitude;
  final double longitude;

  GeoCode({
    required this.name,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
  });

  static GeoCode fromJson(Map<String, dynamic> data) {
    return GeoCode(
      name: data[nameKey],
      countryCode: data[countryCodeKey],
      latitude: data[latitudeKey],
      longitude: data[longitudeKey],
    );
  }

  toJson() {
    return {
      nameKey: name,
      countryCodeKey: countryCode,
      latitudeKey: latitude,
      longitudeKey: longitude
    };
  }
}
