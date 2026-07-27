class GardenInfo {
  final String id;
  final String name;
  final String imageUrl;
  final String location;
  final String status;
  final double area;
  final double latitude;   // thêm
  final double longitude;  // thêm

  const GardenInfo({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.location,
    required this.status,
    required this.area,
    required this.latitude,
    required this.longitude,
  });
}