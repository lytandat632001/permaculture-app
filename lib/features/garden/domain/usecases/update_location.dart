import '../entities/location.dart';
import '../repositories/garden_repository.dart';

class UpdateLocation {
  final GardenRepository _repository;
  UpdateLocation(this._repository);
  Future<Location> call(Location location) => _repository.updateLocation(location);
}