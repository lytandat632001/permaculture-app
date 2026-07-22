import 'package:intl/intl.dart';

/// Extension cho DateTime
extension DateExtensions on DateTime {
  /// Định dạng ngày theo mẫu dd/MM/yyyy
  String get formatDate => DateFormat('dd/MM/yyyy').format(this);

  /// Định dạng ngày giờ
  String get formatDateTime => DateFormat('dd/MM/yyyy HH:mm').format(this);

  /// Định dạng thời gian
  String get formatTime => DateFormat('HH:mm').format(this);

  /// Định dạng thứ trong tuần
  String get formatDayOfWeek => DateFormat('EEEE', 'vi_VN').format(this);

  /// Kiểm tra có phải hôm nay không
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Kiểm tra có phải ngày mai không
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Số ngày còn lại từ hôm nay
  int get daysRemaining {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(year, month, day);
    return target.difference(today).inDays;
  }
}