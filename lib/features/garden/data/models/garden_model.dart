import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/garden.dart';

class GardenModel extends Garden {
  const GardenModel({
    required super.id,
    required super.locationId,
    required super.name,
    required super.type,
    super.area,
    super.note,
    required super.createdAt,
    required super.updatedAt,
  });

  factory GardenModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final typeStr = data['type'] as String;
    final type = GardenType.values.firstWhere(
      (t) => t.toString() == 'GardenType.$typeStr',
      orElse: () => GardenType.other,
    );
    return GardenModel(
      id: doc.id,
      locationId: data['locationId'] as String,
      name: data['name'] as String,
      type: type,
      area: (data['area'] as num?)?.toDouble(),
      note: data['note'] as String?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'locationId': locationId,
      'name': name,
      'type': type.toString().split('.').last,
      'area': area,
      'note': note,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
