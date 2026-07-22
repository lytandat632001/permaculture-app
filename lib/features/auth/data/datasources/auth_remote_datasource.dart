import '../../../../core/services/auth_service.dart';
import '../models/user_model.dart';
import '../../domain/entities/user.dart';

/// Data source xác thực từ xa (Firebase)
class AuthRemoteDatasource {
  final AuthService _authService;

  AuthRemoteDatasource(this._authService);

  /// Đăng nhập email
  Future<User> signInWithEmail(String email, String password) async {
    final credential = await _authService.signInWithEmail(
      email: email,
      password: password,
    );
    return UserModel.fromFirebaseUser(credential.user);
  }

  /// Đăng ký email
  Future<User> signUpWithEmail(String email, String password) async {
    final credential = await _authService.signUpWithEmail(
      email: email,
      password: password,
    );
    return UserModel.fromFirebaseUser(credential.user);
  }

  /// Đăng nhập Google
  Future<User?> signInWithGoogle() async {
    final credential = await _authService.signInWithGoogle();
    if (credential?.user == null) return null;
    return UserModel.fromFirebaseUser(credential!.user);
  }

  /// Đăng xuất
  Future<void> signOut() async {
    await _authService.signOut();
  }

  /// Lấy người dùng hiện tại (từ cache)
  User? getCurrentUser() {
    final firebaseUser = _authService.currentUser;
    if (firebaseUser == null) return null;
    return UserModel.fromFirebaseUser(firebaseUser);
  }

  /// Stream trạng thái đăng nhập
  Stream<User?> authStateChanges() {
    return _authService.authStateChanges.map(
      (firebaseUser) => firebaseUser != null
          ? UserModel.fromFirebaseUser(firebaseUser)
          : null,
    );
  }
}