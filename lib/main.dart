import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permaculture_application/features/garden/data/datasources/garden_seed.dart';
import 'package:permaculture_application/firebase_options.dart';
import 'package:provider/provider.dart';
import 'core/di/injection.dart';
import 'core/logger/app_logger.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  AppLogger.init(); // ✅ Bắt buộc phải có để logger hoạt động

  // Tạm thời không seed tự động – sẽ thêm dữ liệu thủ công
  // await GardenSeed.seed(FirebaseFirestore.instance);

  await initializeDependencies();

  runApp(MultiProvider(providers: globalProviders, child: const App()));
}
