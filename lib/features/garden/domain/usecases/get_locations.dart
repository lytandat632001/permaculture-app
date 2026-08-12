import '../entities/location.dart';
import '../repositories/garden_repository.dart';

class GetLocations {
  final GardenRepository _repository;
  GetLocations(this._repository);
  Future<List<Location>> call() => _repository.getLocations();
}
