/// Base class cho các failure
abstract class Failure {
  final String message;
  const Failure(this.message);
}

/// Lỗi server
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Lỗi máy chủ']);
}

/// Lỗi mạng
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Lỗi kết nối mạng']);
}

/// Lỗi cache
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Lỗi bộ nhớ tạm']);
}

/// Lỗi xác thực
class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Lỗi xác thực']);
}

/// Lỗi quyền truy cập
class PermissionFailure extends Failure {
  const PermissionFailure([super.message = 'Không có quyền truy cập']);
}

/// Lỗi không tìm thấy
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Không tìm thấy dữ liệu']);
}

/// Lỗi validation
class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Dữ liệu không hợp lệ']);
}

/// Lỗi không xác định
class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Đã xảy ra lỗi không xác định']);
}