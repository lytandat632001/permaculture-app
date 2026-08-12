enum GardenType {
  nursery,         // Vườn ươm
  vegetable,       // Vườn rau
  flower,          // Vườn hoa
  fruit,           // Vườn cây ăn quả
  medicinal,       // Vườn dược liệu
  forest,          // Vườn rừng
  landscape,       // Vườn cảnh quan
  rooftop,         // Vườn sân thượng
  indoor,          // Vườn trong nhà
  verticalWall,    // Vườn tường đứng
  hydroponics,     // Vườn thủy canh
  aeroponics,      // Vườn khí canh
  aquaponics,      // Vườn Aquaponics
  other,           // Khác
}

class Garden {
  final String id;
  final String locationId;
  final String name;
  final GardenType type;
  final double? area;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Garden({
    required this.id,
    required this.locationId,
    required this.name,
    required this.type,
    this.area,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });
}