import '../repositories/garden_repository.dart';

class DeleteGarden {
  final GardenRepository _repository;
  DeleteGarden(this._repository);

  Future<void> call(String gardenId) => _repository.deleteGarden(gardenId);
}