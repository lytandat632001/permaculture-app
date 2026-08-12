import '../../domain/entities/location.dart';
import '../../domain/entities/garden.dart';
import '../../domain/entities/plant.dart';
import '../../domain/repositories/garden_repository.dart';
import '../datasources/garden_remote_datasource.dart';

class GardenRepositoryImpl implements GardenRepository {
  final GardenRemoteDatasource _datasource;

  GardenRepositoryImpl(this._datasource);

  @override
  Future<List<Location>> getLocations() => _datasource.getLocations();

  @override
  Future<Location> createLocation(Location location) =>
      _datasource.createLocation(location);

  @override
  Future<Location> updateLocation(Location location) =>
      _datasource.updateLocation(location);

  @override
  Future<void> deleteLocation(String locationId) =>
      _datasource.deleteLocation(locationId);

  @override
  Future<List<Garden>> getGardensByLocation(String locationId) =>
      _datasource.getGardensByLocation(locationId);

  @override
  Future<Garden> createGarden(Garden garden) =>
      _datasource.createGarden(garden);

  @override
  Future<Garden> updateGarden(Garden garden) =>
      _datasource.updateGarden(garden);

  @override
  Future<void> deleteGarden(String gardenId) =>
      _datasource.deleteGarden(gardenId);

  @override
  Future<List<Plant>> getPlants(String gardenId) =>
      _datasource.getPlants(gardenId);

  @override
  Future<Plant> createPlant(Plant plant) => _datasource.createPlant(plant);

  @override
  Future<Plant> updatePlant(Plant plant) => _datasource.updatePlant(plant);

  @override
  Future<void> deletePlant(String plantId) => _datasource.deletePlant(plantId);
}
