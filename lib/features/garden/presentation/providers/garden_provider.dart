import 'package:flutter/material.dart';
import '../../domain/entities/location.dart';
import '../../domain/entities/garden.dart';
import '../../domain/entities/plant.dart';
import '../../domain/usecases/get_locations.dart';
import '../../domain/usecases/create_location.dart';
import '../../domain/usecases/update_location.dart';
import '../../domain/usecases/delete_location.dart';
import '../../domain/usecases/get_gardens_by_location.dart';
import '../../domain/usecases/create_garden.dart';
import '../../domain/usecases/update_garden.dart';
import '../../domain/usecases/delete_garden.dart';
import '../../domain/usecases/get_plants.dart';
import '../../domain/usecases/create_plant.dart';
import '../../domain/usecases/update_plant.dart';
import '../../domain/usecases/delete_plant.dart';

class GardenProvider extends ChangeNotifier {
  final GetLocations _getLocations;
  final CreateLocation _createLocation;
  final UpdateLocation _updateLocation;
  final DeleteLocation _deleteLocation;
  final GetGardensByLocation _getGardensByLocation;
  final CreateGarden _createGarden;
  final UpdateGarden _updateGarden;
  final DeleteGarden _deleteGarden;
  final GetPlants _getPlants;
  final CreatePlant _createPlant;
  final UpdatePlant _updatePlant;
  final DeletePlant _deletePlant;

  List<Location> _locations = [];
  final Map<String, List<Garden>> _gardensCache = {};
  final Map<String, List<Plant>> _plantsCache = {};

  bool _isLoadingLocations = false;
  bool _isLoadingGardens = false;
  bool _isLoadingPlants = false;
  String? _error;

  GardenProvider({
    required GetLocations getLocations,
    required CreateLocation createLocation,
    required UpdateLocation updateLocation,
    required DeleteLocation deleteLocation,
    required GetGardensByLocation getGardensByLocation,
    required CreateGarden createGarden,
    required UpdateGarden updateGarden,
    required DeleteGarden deleteGarden,
    required GetPlants getPlants,
    required CreatePlant createPlant,
    required UpdatePlant updatePlant,
    required DeletePlant deletePlant,
  }) : _getLocations = getLocations,
       _createLocation = createLocation,
       _updateLocation = updateLocation,
       _deleteLocation = deleteLocation,
       _getGardensByLocation = getGardensByLocation,
       _createGarden = createGarden,
       _updateGarden = updateGarden,
       _deleteGarden = deleteGarden,
       _getPlants = getPlants,
       _createPlant = createPlant,
       _updatePlant = updatePlant,
       _deletePlant = deletePlant;

  List<Location> get locations => _locations;
  bool get isLoadingLocations => _isLoadingLocations;
  bool get isLoadingGardens => _isLoadingGardens;
  bool get isLoadingPlants => _isLoadingPlants;
  String? get error => _error;

  List<Garden> gardensForLocation(String locationId) =>
      _gardensCache[locationId] ?? [];
  List<Plant> plantsForGarden(String gardenId) => _plantsCache[gardenId] ?? [];

  // ───────────────────── Locations ─────────────────────
  Future<void> loadLocations() async {
    print('🔄 loadLocations called');
    _isLoadingLocations = true;
    _error = null;
    notifyListeners();
    try {
      final locations = await _getLocations();
      print('✅ Locations loaded: ${locations.length} items');
      _locations = locations;
    } catch (e) {
      print('❌ Error loading locations: $e');
      _error = 'Không thể tải danh sách vị trí';
    }
    _isLoadingLocations = false;
    notifyListeners();
    print('➡️ loadLocations finished, isLoading=$_isLoadingLocations');
  }

  Future<void> addLocation({
    required String name,
    String? address,
    required double latitude,
    required double longitude,
    String? note,
  }) async {
    final location = Location(
      id: '',
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
      note: note,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    final newLoc = await _createLocation(location);
    _locations.insert(0, newLoc);
    notifyListeners();
  }

  Future<void> editLocation(Location location) async {
    final updated = await _updateLocation(location);
    final index = _locations.indexWhere((l) => l.id == location.id);
    if (index != -1) {
      _locations[index] = updated;
      notifyListeners();
    }
  }

  Future<void> removeLocation(String locationId) async {
    await _deleteLocation(locationId);
    _locations.removeWhere((l) => l.id == locationId);
    _gardensCache.remove(locationId);
    notifyListeners();
  }

  // ───────────────────── Gardens ─────────────────────
  Future<void> loadGardens(String locationId) async {
    _isLoadingGardens = true;
    notifyListeners();
    try {
      final gardens = await _getGardensByLocation(locationId);
      _gardensCache[locationId] = gardens;
    } catch (e) {
      _error = 'Không thể tải danh sách vườn';
    }
    _isLoadingGardens = false;
    notifyListeners();
  }

  Future<void> addGarden({
    required String locationId,
    required String name,
    required GardenType type,
    double? area,
    String? note,
  }) async {
    final garden = Garden(
      id: '',
      locationId: locationId,
      name: name,
      type: type,
      area: area,
      note: note,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    final newGarden = await _createGarden(garden);
    _gardensCache.putIfAbsent(locationId, () => []);
    _gardensCache[locationId]!.insert(0, newGarden);
    notifyListeners();
  }

  Future<void> editGarden(Garden garden) async {
    final updated = await _updateGarden(garden);
    final list = _gardensCache[garden.locationId];
    if (list != null) {
      final index = list.indexWhere((g) => g.id == garden.id);
      if (index != -1) {
        list[index] = updated;
        notifyListeners();
      }
    }
  }

  Future<void> removeGarden(String gardenId, String locationId) async {
    await _deleteGarden(gardenId);
    _gardensCache[locationId]?.removeWhere((g) => g.id == gardenId);
    notifyListeners();
  }

  // ───────────────────── Plants ─────────────────────
  Future<void> loadPlants(String gardenId) async {
    _isLoadingPlants = true;
    notifyListeners();
    try {
      final plants = await _getPlants(gardenId);
      _plantsCache[gardenId] = plants;
    } catch (e) {
      _error = 'Không thể tải danh sách cây';
    }
    _isLoadingPlants = false;
    notifyListeners();
  }

  Future<void> addPlant({
    required String gardenId,
    required String name,
    String? species,
    DateTime? plantingDate,
    String? notes,
  }) async {
    final plant = Plant(
      id: '',
      gardenId: gardenId,
      name: name,
      species: species,
      plantingDate: plantingDate,
      notes: notes,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    final newPlant = await _createPlant(plant);
    _plantsCache.putIfAbsent(gardenId, () => []);
    _plantsCache[gardenId]!.insert(0, newPlant);
    notifyListeners();
  }

  Future<void> editPlant(Plant plant) async {
    final updated = await _updatePlant(plant);
    final list = _plantsCache[plant.gardenId];
    if (list != null) {
      final index = list.indexWhere((p) => p.id == plant.id);
      if (index != -1) {
        list[index] = updated;
        notifyListeners();
      }
    }
  }

  Future<void> removePlant(String plantId, String gardenId) async {
    await _deletePlant(plantId);
    _plantsCache[gardenId]?.removeWhere((p) => p.id == plantId);
    notifyListeners();
  }
}
