import '../entities/user.dart';

/// Interface Repository cho Auth
abstract class AuthRepository {
  /// Đăng nhập email
  Future<User> signInWithEmail(String email, String password);

  /// Đăng ký email
  Future<User> signUpWithEmail(String email, String password);

  /// Đăng nhập Google
  Future<User?> signInWithGoogle();

  /// Đăng xuất
  Future<void> signOut();

  /// Lấy người dùng hiện tại (từ cache)
  User? getCurrentUser();

  /// Stream trạng thái đăng nhập
  Stream<User?> get authStateChanges;
}