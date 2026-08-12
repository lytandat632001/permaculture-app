import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/plant.dart';

class PlantModel extends Plant {
  const PlantModel({
    required super.id,
    required super.gardenId,
    required super.name,
    super.species,
    super.plantingDate,
    super.notes,
    required super.createdAt,
    required super.updatedAt,
  });

  factory PlantModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PlantModel(
      id: doc.id,
      gardenId: data['gardenId'] as String,
      name: data['name'] as String,
      species: data['species'] as String?,
      plantingDate: data['plantingDate'] != null
          ? (data['plantingDate'] as Timestamp).toDate()
          : null,
      notes: data['notes'] as String?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'gardenId': gardenId,
    'name': name,
    'species': species,
    'plantingDate': plantingDate != null
        ? Timestamp.fromDate(plantingDate!)
        : null,
    'notes': notes,
    'createdAt': FieldValue.serverTimestamp(),
    'updatedAt': FieldValue.serverTimestamp(),
  };
}
