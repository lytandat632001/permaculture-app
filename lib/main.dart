import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permaculture_application/firebase_options.dart';
import 'package:provider/provider.dart';
import 'core/di/injection.dart'; // ← THÊM DÒNG NÀY
import 'core/logger/app_logger.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  AppLogger.init();

  await initializeDependencies(); // bây giờ đã được định nghĩa

  runApp(
    MultiProvider(
      providers: globalProviders, // bây giờ đã được định nghĩa
      child: const App(),
    ),
  );
}
