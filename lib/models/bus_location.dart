
class BusLocation {
  final double latitude;
  final double longitude;

  BusLocation({
    required this.latitude,
    required this.longitude,

  });

  factory BusLocation.fromJson(Map<String, dynamic> json) {
    return BusLocation(
      latitude: json['latitude'],
      longitude: json['longitude'],

    );
  }
}