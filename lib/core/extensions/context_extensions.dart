import 'package:flutter/material.dart';

/// Extension cho BuildContext
extension ContextExtensions on BuildContext {
  /// Lấy theme hiện tại
  ThemeData get theme => Theme.of(this);

  /// Lấy color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Lấy text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Lấy kích thước màn hình
  Size get screenSize => MediaQuery.of(this).size;

  /// Lấy padding an toàn
  EdgeInsets get safePadding => MediaQuery.of(this).padding;

  /// Kiểm tra chế độ tối
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}