/// Các exception trong ứng dụng

/// Lỗi server
class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Lỗi máy chủ']);
}

/// Lỗi mạng
class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'Lỗi kết nối mạng']);
}

/// Lỗi xác thực
class AuthException implements Exception {
  final String message;
  const AuthException([this.message = 'Lỗi xác thực']);
}

/// Lỗi quyền truy cập
class PermissionException implements Exception {
  final String message;
  const PermissionException([this.message = 'Không có quyền truy cập']);
}

/// Lỗi dữ liệu không tồn tại
class NotFoundException implements Exception {
  final String message;
  const NotFoundException([this.message = 'Không tìm thấy dữ liệu']);
}

/// Lỗi validation
class ValidationException implements Exception {
  final String message;
  const ValidationException([this.message = 'Dữ liệu không hợp lệ']);
}