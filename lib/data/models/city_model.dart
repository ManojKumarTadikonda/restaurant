class City {
  final String name;
  final String? region;
  final double lat;
  final double lng;

  City({
    required this.name,
    this.region,
    required this.lat,
    required this.lng,
  });
  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'] ?? '',
      region: json['region'],
      lat: (json['lat'] ?? 0).toDouble(),
      lng: (json['lng'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'region': region,
      'lat': lat,
      'lng': lng,
    };
  }
}
