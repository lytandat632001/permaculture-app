import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firebase_collections.dart';

class GardenSeed {
  static Future<void> seed(FirebaseFirestore firestore) async {
    // Xóa hết dữ liệu cũ (nếu cần)
    // await _deleteAll(firestore);

    // 1. Tạo locations
    final loc1Ref = await firestore
        .collection(FirebaseCollections.locations)
        .add({
          'name': 'Định Quán',
          'address': 'Định Quán, Đồng Nai',
          'latitude': 11.191,
          'longitude': 107.561,
          'note': 'Khu vực trồng ca cao',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
    final loc2Ref = await firestore
        .collection(FirebaseCollections.locations)
        .add({
          'name': 'Đà Lạt',
          'address': 'Đà Lạt, Lâm Đồng',
          'latitude': 11.946,
          'longitude': 108.442,
          'note': 'Khu vực rau organic',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
    final loc3Ref = await firestore
        .collection(FirebaseCollections.locations)
        .add({
          'name': 'Củ Chi',
          'address': 'Củ Chi, TP.HCM',
          'latitude': 10.973,
          'longitude': 106.493,
          'note': 'Khu vực cây ăn trái',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

    // 2. Tạo gardens
    final garden1 = await firestore
        .collection(FirebaseCollections.gardenPlots)
        .add({
          'locationId': loc1Ref.id,
          'name': 'Vườn ca cao',
          'type': 'fruit',
          'area': 2500,
          'note': 'Giống ca cao lai',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
    await firestore.collection(FirebaseCollections.gardenPlots).add({
      'locationId': loc1Ref.id,
      'name': 'Vườn rau',
      'type': 'vegetable',
      'area': 800,
      'note': 'Rau hữu cơ',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    await firestore.collection(FirebaseCollections.gardenPlots).add({
      'locationId': loc2Ref.id,
      'name': 'Vườn ươm',
      'type': 'nursery',
      'area': 300,
      'note': 'Cây giống các loại',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    await firestore.collection(FirebaseCollections.gardenPlots).add({
      'locationId': loc2Ref.id,
      'name': 'Vườn hoa',
      'type': 'flower',
      'area': 500,
      'note': 'Hoa cắt cành',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    await firestore.collection(FirebaseCollections.gardenPlots).add({
      'locationId': loc3Ref.id,
      'name': 'Vườn cây ăn trái',
      'type': 'fruit',
      'area': 5000,
      'note': 'Xoài, bơ, sầu riêng',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // 3. Tạo plants
    await firestore.collection(FirebaseCollections.plants).add({
      'gardenId': garden1.id,
      'name': 'Cà chua',
      'species': 'Solanum lycopersicum',
      'plantingDate': DateTime(2026, 5, 15),
      'notes': 'Giống cà chua bi',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    await firestore.collection(FirebaseCollections.plants).add({
      'gardenId': garden1.id,
      'name': 'Xà lách',
      'species': 'Lactuca sativa',
      'plantingDate': DateTime(2026, 6, 1),
      'notes': '',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    print('Seed data completed!');
  }
}
