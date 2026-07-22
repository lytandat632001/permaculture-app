import 'package:flutter/material.dart';
import '../logger/app_logger.dart';

/// Observer quản lý vòng đời ứng dụng
class AppLifecycle extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        AppLogger.info('App resumed');
      case AppLifecycleState.inactive:
        AppLogger.info('App inactive');
      case AppLifecycleState.paused:
        AppLogger.info('App paused');
      case AppLifecycleState.detached:
        AppLogger.info('App detached');
      case AppLifecycleState.hidden:
        AppLogger.info('App hidden');
    }
  }
}