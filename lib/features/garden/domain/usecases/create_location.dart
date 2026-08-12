import '../entities/location.dart';
import '../repositories/garden_repository.dart';

class CreateLocation {
  final GardenRepository _repository;
  CreateLocation(this._repository);
  Future<Location> call(Location location) => _repository.createLocation(location);
}