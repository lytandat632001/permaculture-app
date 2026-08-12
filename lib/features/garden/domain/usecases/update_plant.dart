import '../entities/plant.dart';
import '../repositories/garden_repository.dart';

class UpdatePlant {
  final GardenRepository _repository;
  UpdatePlant(this._repository);
  Future<Plant> call(Plant plant) => _repository.updatePlant(plant);
}