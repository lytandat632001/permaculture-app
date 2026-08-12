import '../entities/garden.dart';
import '../repositories/garden_repository.dart';

class UpdateGarden {
  final GardenRepository _repository;
  UpdateGarden(this._repository);

  Future<Garden> call(Garden garden) => _repository.updateGarden(garden);
}