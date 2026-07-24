class GardenInfo {
  final String id;
  final String name;
  final String imageUrl;
  final String location;
  final String status; // 'active', 'inactive'
  final double area; // m2

  const GardenInfo({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.location,
    required this.status,
    required this.area,
  });
}
