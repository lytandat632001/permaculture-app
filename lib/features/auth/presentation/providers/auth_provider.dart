import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_up.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../../../core/errors/exceptions.dart';


/// Trạng thái xác thực
enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  loading,
  error,
}

/// Provider quản lý xác thực
class AuthProvider extends ChangeNotifier {
  final SignIn _signIn;
  final SignUp _signUp;
  final SignInWithGoogle _googleSignIn;
  final SignOut _signOut;
  final GetCurrentUser _getCurrentUser;

  AuthStatus _status = AuthStatus.initial;
  User? _user;
  String? _errorMessage;

  AuthProvider({
    required SignIn signIn,
    required SignUp signUp,
    required SignInWithGoogle googleSignIn,
    required SignOut signOut,
    required GetCurrentUser getCurrentUser,
  })  : _signIn = signIn,
        _signUp = signUp,
        _googleSignIn = googleSignIn,
        _signOut = signOut,
        _getCurrentUser = getCurrentUser;

  AuthStatus get status => _status;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  /// Kiểm tra trạng thái đăng nhập hiện tại
  void checkAuthStatus() {
    _user = _getCurrentUser();
    if (_user != null) {
      _status = AuthStatus.authenticated;
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  /// Đăng nhập email
  Future<void> login(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _signIn(email, password);
      _status = AuthStatus.authenticated;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = _mapError(e);
    }
    notifyListeners();
  }

  /// Đăng ký email
  Future<void> register(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _signUp(email, password);
      _status = AuthStatus.authenticated;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = _mapError(e);
    }
    notifyListeners();
  }

  /// Đăng nhập Google
  Future<void> loginWithGoogle() async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _googleSignIn();
      if (_user != null) {
        _status = AuthStatus.authenticated;
      } else {
        // Người dùng hủy
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = _mapError(e);
    }
    notifyListeners();
  }

  /// Đăng xuất
  Future<void> logout() async {
    await _signOut();
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  /// Ánh xạ lỗi thành thông báo thân thiện
  String _mapError(dynamic error) {
    if (error is AuthException) {
      return error.message;
    }
    if (error is Exception) {
      return error.toString();
    }
    return 'Đã xảy ra lỗi không xác định';
  }

  /// Xóa lỗi
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}