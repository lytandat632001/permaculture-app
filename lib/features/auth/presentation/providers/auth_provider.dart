import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_up.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/router/auth_notifier.dart'; // thêm import

enum AuthStatus { initial, authenticated, unauthenticated, loading, error }

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
  }) : _signIn = signIn,
       _signUp = signUp,
       _googleSignIn = googleSignIn,
       _signOut = signOut,
       _getCurrentUser = getCurrentUser;

  AuthStatus get status => _status;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  // ========== THÊM HÀM NÀY ==========
  void _updateAuthNotifier() {
    authNotifier.value = isAuthenticated;
  }

  void checkAuthStatus() {
    _user = _getCurrentUser();
    _status = _user != null
        ? AuthStatus.authenticated
        : AuthStatus.unauthenticated;
    _updateAuthNotifier(); // <-- gọi ở đây
    notifyListeners();
  }

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
    _updateAuthNotifier(); // <-- gọi ở đây
    notifyListeners();
  }

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
    _updateAuthNotifier(); // <-- gọi ở đây
    notifyListeners();
  }

  Future<void> loginWithGoogle() async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      _user = await _googleSignIn();
      _status = _user != null
          ? AuthStatus.authenticated
          : AuthStatus.unauthenticated;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = _mapError(e);
    }
    _updateAuthNotifier(); // <-- gọi ở đây
    notifyListeners();
  }

  Future<void> logout() async {
    await _signOut();
    _user = null;
    _status = AuthStatus.unauthenticated;
    _updateAuthNotifier(); // <-- gọi ở đây
    notifyListeners();
  }

  String _mapError(dynamic error) {
    if (error is AuthException) return error.message;
    if (error is Exception) return error.toString();
    return 'Đã xảy ra lỗi không xác định';
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
