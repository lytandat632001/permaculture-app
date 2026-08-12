import '../entities/garden.dart';
import '../repositories/garden_repository.dart';

class CreateGarden {
  final GardenRepository _repository;
  CreateGarden(this._repository);

  Future<Garden> call(Garden garden) => _repository.createGarden(garden);
}