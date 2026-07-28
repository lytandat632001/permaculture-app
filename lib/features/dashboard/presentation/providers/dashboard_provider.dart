// lib/features/dashboard/presentation/providers/dashboard_provider.dart

import 'package:flutter/material.dart';
import '../../domain/entities/garden_dashboard.dart';
import '../../domain/usecases/get_garden_weather.dart';
import '../../domain/usecases/get_gardens_dashboard.dart';

class DashboardProvider extends ChangeNotifier {
  final GetGardensDashboard _getGardensDashboard;
  final GetGardenWeather _getGardenWeather;

  List<GardenDashboard> _gardens = [];
  bool _isLoading = true;
  String? _error;

  DashboardProvider({
    required GetGardensDashboard getGardensDashboard,
    required GetGardenWeather getGardenWeather,
  }) : _getGardensDashboard = getGardensDashboard,
       _getGardenWeather = getGardenWeather {
    load();
  }

  List<GardenDashboard> get gardens => _gardens;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get gardenCount => _gardens.length;
  int get totalAlerts =>
      _gardens.fold(0, (sum, g) => sum + g.alertSummary.alerts.length);

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final gardenList = await _getGardensDashboard();

      final updatedGardens = await Future.wait(
        gardenList.map((garden) async {
          // ========== THÊM LOG Ở ĐÂY ==========
          print(
            '📍 Đang lấy thời tiết cho ${garden.info.name} (${garden.info.latitude}, ${garden.info.longitude})',
          );
          try {
            final weather = await _getGardenWeather(
              garden.info.latitude,
              garden.info.longitude,
            );
            // ========== LOG THÀNH CÔNG ==========
            print('✅ Thành công: ${garden.info.name}');
            return GardenDashboard(
              info: garden.info,
              weather: weather,
              sensors: garden.sensors,
              deviceSummary: garden.deviceSummary,
              taskSummary: garden.taskSummary,
              eventSummary: garden.eventSummary,
              alertSummary: garden.alertSummary,
            );
          } catch (e) {
            // ========== LOG THẤT BẠI ==========
            print('❌ Thất bại ${garden.info.name}: $e');
            return garden;
          }
        }),
      );

      _gardens = updatedGardens;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() => load();
}
