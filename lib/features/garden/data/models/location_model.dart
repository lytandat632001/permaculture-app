import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/location.dart';

class LocationModel extends Location {
  const LocationModel({
    required super.id,
    required super.name,
    super.address,
    required super.latitude,
    required super.longitude,
    super.note,
    required super.createdAt,
    required super.updatedAt,
  });

  factory LocationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LocationModel(
      id: doc.id,
      name: data['name'] as String,
      address: data['address'] as String?,
      latitude: (data['latitude'] as num).toDouble(),
      longitude: (data['longitude'] as num).toDouble(),
      note: data['note'] as String?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'note': note,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
