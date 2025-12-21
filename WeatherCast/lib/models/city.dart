class City {
  final String name;
  final double lat;
  final double lon;
  final String? country;
  final String? state;

  City({
    required this.name,
    required this.lat,
    required this.lon,
    this.country,
    this.state,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'] ?? '',
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      country: json['country'],
      state: json['state'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lat': lat,
      'lon': lon,
      'country': country,
      'state': state,
    };
  }

  String get displayName {
    if (state != null && country != null) {
      return '$name, $state, $country';
    } else if (country != null) {
      return '$name, $country';
    }
    return name;
  }
}
