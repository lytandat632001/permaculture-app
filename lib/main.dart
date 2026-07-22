import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permaculture_application/firebase_options.dart';
import 'package:provider/provider.dart';
import 'core/di/injection.dart';
import 'core/logger/app_logger.dart';
import 'core/lifecycle/app_lifecycle.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Khởi tạo Logger
  AppLogger.init();

  // Khởi tạo Dependency Injection
  await initializeDependencies();

  // Chạy ứng dụng
  runApp(
    MultiProvider(
      providers: globalProviders,
      child: const App(),
    ),
  );
}