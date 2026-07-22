import 'package:logger/logger.dart';

/// Logger tập trung của ứng dụng
class AppLogger {
  AppLogger._();

  static late final Logger _logger;

  /// Khởi tạo logger
  static void init() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
    );
  }

  /// Log thông tin debug
  static void debug(String message) => _logger.d(message);

  /// Log thông tin
  static void info(String message) => _logger.i(message);

  /// Log cảnh báo
  static void warning(String message) => _logger.w(message);

  /// Log lỗi
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}