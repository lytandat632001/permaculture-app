import '../entities/plant.dart';
import '../repositories/garden_repository.dart';

class CreatePlant {
  final GardenRepository _repository;
  CreatePlant(this._repository);
  Future<Plant> call(Plant plant) => _repository.createPlant(plant);
}