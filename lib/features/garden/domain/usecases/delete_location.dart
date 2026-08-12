import '../repositories/garden_repository.dart';

class DeleteLocation {
  final GardenRepository _repository;
  DeleteLocation(this._repository);
  Future<void> call(String locationId) => _repository.deleteLocation(locationId);
}