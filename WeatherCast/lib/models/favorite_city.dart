class FavoriteCity {
  final int? id;
  final String name;
  final double lat;
  final double lon;
  final String? country;
  final DateTime createdAt;

  FavoriteCity({
    this.id,
    required this.name,
    required this.lat,
    required this.lon,
    this.country,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'lat': lat,
      'lon': lon,
      'country': country,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Create from Map (SQLite)
  factory FavoriteCity.fromMap(Map<String, dynamic> map) {
    return FavoriteCity(
      id: map['id'],
      name: map['name'],
      lat: map['lat'],
      lon: map['lon'],
      country: map['country'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  String get displayName {
    if (country != null) {
      return '$name, $country';
    }
    return name;
  }

  // Copy with method for updates
  FavoriteCity copyWith({
    int? id,
    String? name,
    double? lat,
    double? lon,
    String? country,
    DateTime? createdAt,
  }) {
    return FavoriteCity(
      id: id ?? this.id,
      name: name ?? this.name,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      country: country ?? this.country,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
