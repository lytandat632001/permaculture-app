import 'package:intl/intl.dart';

/// Các hàm tiện ích chung
class Helpers {
  Helpers._();

  /// Định dạng số
  static String formatNumber(num number) {
    return NumberFormat('#,###').format(number);
  }

  /// Định dạng tiền tệ
  static String formatCurrency(num amount) {
    return NumberFormat('#,### đ').format(amount);
  }

  /// Định dạng ngày tháng
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Định dạng ngày giờ
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  /// Chuyển đổi nhiệt độ Celsius sang Fahrenheit
  static double celsiusToFahrenheit(double celsius) {
    return (celsius * 9 / 5) + 32;
  }

  /// Kiểm tra email hợp lệ
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Kiểm tra mật khẩu hợp lệ (tối thiểu 6 ký tự)
  static bool isValidPassword(String password) {
    return password.length >= 6;
  }
}
