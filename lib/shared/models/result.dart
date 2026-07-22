/// Kết quả trả về từ các operation
sealed class Result<T> {
  const Result();
}

/// Thành công
class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

/// Thất bại
class Failure<T> extends Result<T> {
  final String message;
  final dynamic error;
  const Failure(this.message, [this.error]);
}

/// Đang tải
class Loading<T> extends Result<T> {
  const Loading();
}