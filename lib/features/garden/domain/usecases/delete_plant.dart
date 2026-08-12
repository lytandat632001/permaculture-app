import '../repositories/garden_repository.dart';

class DeletePlant {
  final GardenRepository _repository;
  DeletePlant(this._repository);
  Future<void> call(String plantId) => _repository.deletePlant(plantId);
}
