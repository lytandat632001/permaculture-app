class Location {
  final String id;
  final String name;
  final String? address;
  final double latitude;
  final double longitude;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Location({
    required this.id,
    required this.name,
    this.address,
    required this.latitude,
    required this.longitude,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });
}
