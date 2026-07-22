import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'failures.dart';
import '../logger/app_logger.dart';

/// Xử lý lỗi và chuyển đổi thành Failure
class ErrorHandler {
  ErrorHandler._();

  /// Chuyển đổi exception thành Failure
  static Failure handle(dynamic error) {
    AppLogger.error('Error occurred', error);

    if (error is FirebaseAuthException) {
      return _handleAuthError(error);
    }

    if (error is FirebaseException) {
      return _handleFirebaseError(error);
    }

    if (error is Failure) {
      return error;
    }

    return const UnknownFailure();
  }

  /// Xử lý lỗi Firebase Auth
  static Failure _handleAuthError(FirebaseAuthException error) {
    switch (error.code) {
      case 'user-not-found':
        return const AuthFailure('Không tìm thấy người dùng');
      case 'wrong-password':
        return const AuthFailure('Mật khẩu không chính xác');
      case 'email-already-in-use':
        return const AuthFailure('Email đã được sử dụng');
      case 'invalid-email':
        return const AuthFailure('Email không hợp lệ');
      case 'weak-password':
        return const AuthFailure('Mật khẩu quá yếu');
      case 'user-disabled':
        return const AuthFailure('Tài khoản đã bị vô hiệu hóa');
      case 'network-request-failed':
        return const NetworkFailure();
      default:
        return AuthFailure(error.message ?? 'Lỗi xác thực');
    }
  }

  /// Xử lý lỗi Firebase
  static Failure _handleFirebaseError(FirebaseException error) {
    switch (error.code) {
      case 'unavailable':
        return const NetworkFailure('Không có kết nối mạng');
      case 'permission-denied':
        return const PermissionFailure();
      case 'not-found':
        return const NotFoundFailure();
      default:
        return ServerFailure(error.message ?? 'Lỗi máy chủ');
    }
  }
}