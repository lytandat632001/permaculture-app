import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

/// Triển khai AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remoteDatasource;

  AuthRepositoryImpl(this._remoteDatasource);

  @override
  Future<User> signInWithEmail(String email, String password) async {
    return _remoteDatasource.signInWithEmail(email, password);
  }

  @override
  Future<User> signUpWithEmail(String email, String password) async {
    return _remoteDatasource.signUpWithEmail(email, password);
  }

  @override
  Future<User?> signInWithGoogle() async {
    return _remoteDatasource.signInWithGoogle();
  }

  @override
  Future<void> signOut() async {
    await _remoteDatasource.signOut();
  }

  @override
  User? getCurrentUser() => _remoteDatasource.getCurrentUser();

  @override
  Stream<User?> get authStateChanges => _remoteDatasource.authStateChanges();
}