import 'garden.dart';

String gardenTypeName(GardenType type) {
  switch (type) {
    case GardenType.nursery:
      return 'Vườn ươm';
    case GardenType.vegetable:
      return 'Vườn rau';
    case GardenType.flower:
      return 'Vườn hoa';
    case GardenType.fruit:
      return 'Vườn cây ăn quả';
    case GardenType.medicinal:
      return 'Vườn dược liệu';
    case GardenType.forest:
      return 'Vườn rừng';
    case GardenType.landscape:
      return 'Vườn cảnh quan';
    case GardenType.rooftop:
      return 'Vườn sân thượng';
    case GardenType.indoor:
      return 'Vườn trong nhà';
    case GardenType.verticalWall:
      return 'Vườn tường đứng';
    case GardenType.hydroponics:
      return 'Vườn thủy canh';
    case GardenType.aeroponics:
      return 'Vườn khí canh';
    case GardenType.aquaponics:
      return 'Vườn Aquaponics';
    case GardenType.other:
      return 'Khác';
  }
}
