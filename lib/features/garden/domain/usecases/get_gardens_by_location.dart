import '../entities/garden.dart';
import '../repositories/garden_repository.dart';

class GetGardensByLocation {
  final GardenRepository _repository;
  GetGardensByLocation(this._repository);
  Future<List<Garden>> call(String locationId) =>
      _repository.getGardensByLocation(locationId);
}