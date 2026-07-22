import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// Global providers được sử dụng trong MultiProvider ở main.dart
final List<SingleChildWidget> globalProviders = [];

/// Khởi tạo dependencies
Future<void> initializeDependencies() async {
  // TODO: Đăng ký services, repositories, usecases, providers khi phát triển
}