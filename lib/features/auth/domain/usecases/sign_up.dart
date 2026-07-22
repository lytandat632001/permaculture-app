import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignUp {
  final AuthRepository _repository;
  SignUp(this._repository);

  Future<User> call(String email, String password) async {
    return _repository.signUpWithEmail(email, password);
  }
}