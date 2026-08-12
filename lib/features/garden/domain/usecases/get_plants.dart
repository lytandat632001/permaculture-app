import '../entities/plant.dart';
import '../repositories/garden_repository.dart';

class GetPlants {
  final GardenRepository _repository;
  GetPlants(this._repository);
  Future<List<Plant>> call(String gardenId) => _repository.getPlants(gardenId);
}
