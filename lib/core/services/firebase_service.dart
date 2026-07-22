import 'package:firebase_core/firebase_core.dart';
import '../logger/app_logger.dart';

/// Service quản lý Firebase
class FirebaseService {
  FirebaseService._();

  static FirebaseApp? _app;

  /// Khởi tạo Firebase
  static Future<FirebaseApp> initialize() async {
    if (_app != null) return _app!;

    _app = await Firebase.initializeApp();
    AppLogger.info('Firebase initialized');
    return _app!;
  }

  /// Lấy instance FirebaseApp hiện tại
  static FirebaseApp get instance {
    if (_app == null) {
      throw Exception('Firebase chưa được khởi tạo');
    }
    return _app!;
  }
}