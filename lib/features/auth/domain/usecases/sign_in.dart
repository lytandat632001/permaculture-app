import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignIn {
  final AuthRepository _repository;
  SignIn(this._repository);

  Future<User> call(String email, String password) async {
    return _repository.signInWithEmail(email, password);
  }
}