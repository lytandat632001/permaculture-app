import '../../domain/entities/garden_info.dart';

class GardenInfoModel extends GardenInfo {
  const GardenInfoModel({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.location,
    required super.status,
    required super.area,
  });

  factory GardenInfoModel.fromJson(Map<String, dynamic> json) {
    return GardenInfoModel(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      location: json['location'] as String,
      status: json['status'] as String,
      area: (json['area'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'imageUrl': imageUrl,
    'location': location,
    'status': status,
    'area': area,
  };
}
