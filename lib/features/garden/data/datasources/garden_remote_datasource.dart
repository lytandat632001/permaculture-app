import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/location_model.dart';
import '../models/garden_model.dart';
import '../models/plant_model.dart';
import '../../domain/entities/location.dart';
import '../../domain/entities/garden.dart';
import '../../domain/entities/plant.dart';
import '../../../../core/constants/firebase_collections.dart';

class GardenRemoteDatasource {
  final FirebaseFirestore _firestore;

  GardenRemoteDatasource(this._firestore);

  // ───────────────────── Location ─────────────────────
  Future<List<Location>> getLocations() async {
    print('📡 getLocations datasource called');
    final snapshot = await _firestore
        .collection(FirebaseCollections.locations)
        .orderBy('createdAt', descending: true)
        .get();
    print('📄 Snapshot docs count: ${snapshot.docs.length}');
    return snapshot.docs
        .map((doc) => LocationModel.fromFirestore(doc))
        .toList();
  }

  Future<Location> createLocation(Location location) async {
    final model = LocationModel(
      id: '',
      name: location.name,
      address: location.address,
      latitude: location.latitude,
      longitude: location.longitude,
      note: location.note,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    final docRef = await _firestore
        .collection(FirebaseCollections.locations)
        .add(model.toFirestore());
    final doc = await docRef.get();
    return LocationModel.fromFirestore(doc);
  }

  Future<Location> updateLocation(Location location) async {
    final model = LocationModel(
      id: location.id,
      name: location.name,
      address: location.address,
      latitude: location.latitude,
      longitude: location.longitude,
      note: location.note,
      createdAt: location.createdAt,
      updatedAt: DateTime.now(),
    );
    await _firestore
        .collection(FirebaseCollections.locations)
        .doc(location.id)
        .update(model.toFirestore());
    final doc = await _firestore
        .collection(FirebaseCollections.locations)
        .doc(location.id)
        .get();
    return LocationModel.fromFirestore(doc);
  }

  Future<void> deleteLocation(String locationId) async {
    await _firestore
        .collection(FirebaseCollections.locations)
        .doc(locationId)
        .delete();
  }

  // ───────────────────── Garden ─────────────────────
  Future<List<Garden>> getGardensByLocation(String locationId) async {
    final snapshot = await _firestore
        .collection(FirebaseCollections.gardenPlots)
        .where('locationId', isEqualTo: locationId)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((doc) => GardenModel.fromFirestore(doc)).toList();
  }

  Future<Garden> createGarden(Garden garden) async {
    final model = GardenModel(
      id: '',
      locationId: garden.locationId,
      name: garden.name,
      type: garden.type,
      area: garden.area,
      note: garden.note,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    final docRef = await _firestore
        .collection(FirebaseCollections.gardenPlots)
        .add(model.toFirestore());
    final doc = await docRef.get();
    return GardenModel.fromFirestore(doc);
  }

  Future<Garden> updateGarden(Garden garden) async {
    final model = GardenModel(
      id: garden.id,
      locationId: garden.locationId,
      name: garden.name,
      type: garden.type,
      area: garden.area,
      note: garden.note,
      createdAt: garden.createdAt,
      updatedAt: DateTime.now(),
    );
    await _firestore
        .collection(FirebaseCollections.gardenPlots)
        .doc(garden.id)
        .update(model.toFirestore());
    final doc = await _firestore
        .collection(FirebaseCollections.gardenPlots)
        .doc(garden.id)
        .get();
    return GardenModel.fromFirestore(doc);
  }

  Future<void> deleteGarden(String gardenId) async {
    await _firestore
        .collection(FirebaseCollections.gardenPlots)
        .doc(gardenId)
        .delete();
  }

  // ───────────────────── Plant ─────────────────────
  Future<List<Plant>> getPlants(String gardenId) async {
    final snapshot = await _firestore
        .collection(FirebaseCollections.plants)
        .where('gardenId', isEqualTo: gardenId)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((doc) => PlantModel.fromFirestore(doc)).toList();
  }

  Future<Plant> createPlant(Plant plant) async {
    final model = PlantModel(
      id: '',
      gardenId: plant.gardenId,
      name: plant.name,
      species: plant.species,
      plantingDate: plant.plantingDate,
      notes: plant.notes,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    final docRef = await _firestore
        .collection(FirebaseCollections.plants)
        .add(model.toFirestore());
    final doc = await docRef.get();
    return PlantModel.fromFirestore(doc);
  }

  Future<Plant> updatePlant(Plant plant) async {
    final model = PlantModel(
      id: plant.id,
      gardenId: plant.gardenId,
      name: plant.name,
      species: plant.species,
      plantingDate: plant.plantingDate,
      notes: plant.notes,
      createdAt: plant.createdAt,
      updatedAt: DateTime.now(),
    );
    await _firestore
        .collection(FirebaseCollections.plants)
        .doc(plant.id)
        .update(model.toFirestore());
    final doc = await _firestore
        .collection(FirebaseCollections.plants)
        .doc(plant.id)
        .get();
    return PlantModel.fromFirestore(doc);
  }

  Future<void> deletePlant(String plantId) async {
    await _firestore
        .collection(FirebaseCollections.plants)
        .doc(plantId)
        .delete();
  }
}
