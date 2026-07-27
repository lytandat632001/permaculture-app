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
  })  : _getGardensDashboard = getGardensDashboard,
        _getGardenWeather = getGardenWeather {
    load();
  }

  List<GardenDashboard> get gardens => _gardens;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get gardenCount => _gardens.length;
  int get totalAlerts => _gardens.fold(0, (sum, g) => sum + g.alertSummary.alerts.length);

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Bước 1: Lấy danh sách garden với thông tin cơ bản (mock)
      final gardenList = await _getGardensDashboard();

      // Bước 2: Với mỗi garden, lấy thời tiết thật từ API và gán lại
      final updatedGardens = await Future.wait(
        gardenList.map((garden) async {
          try {
            final weather = await _getGardenWeather(
              garden.info.latitude,
              garden.info.longitude,
            );
            return GardenDashboard(
              info: garden.info,
              weather: weather, // ghi đè weather bằng dữ liệu thật
              sensors: garden.sensors,
              deviceSummary: garden.deviceSummary,
              taskSummary: garden.taskSummary,
              eventSummary: garden.eventSummary,
              alertSummary: garden.alertSummary,
            );
          } catch (e) {
            // Nếu không lấy được thời tiết, giữ lại dữ liệu cũ (hoặc mock)
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