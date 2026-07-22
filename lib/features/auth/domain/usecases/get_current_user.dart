import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUser {
  final AuthRepository _repository;
  GetCurrentUser(this._repository);

  User? call() => _repository.getCurrentUser();
}