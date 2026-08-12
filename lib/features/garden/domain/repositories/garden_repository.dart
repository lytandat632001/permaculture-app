import 'package:permaculture_application/features/garden/domain/entities/garden.dart';
import 'package:permaculture_application/features/garden/domain/entities/location.dart';
import 'package:permaculture_application/features/garden/domain/entities/plant.dart';



abstract class GardenRepository {
  // Location CRUD
  Future<List<Location>> getLocations();
  Future<Location> createLocation(Location location);
  Future<Location> updateLocation(Location location);
  Future<void> deleteLocation(String locationId);

  // Garden CRUD
  Future<List<Garden>> getGardensByLocation(String locationId);
  Future<Garden> createGarden(Garden garden);
  Future<Garden> updateGarden(Garden garden);
  Future<void> deleteGarden(String gardenId);

  // Plant CRUD
  Future<List<Plant>> getPlants(String gardenId);
  Future<Plant> createPlant(Plant plant);
  Future<Plant> updatePlant(Plant plant);
  Future<void> deletePlant(String plantId);
}
