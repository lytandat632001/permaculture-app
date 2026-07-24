import 'package:flutter/material.dart';

import '../../domain/entities/garden_dashboard.dart';
import '../../domain/usecases/get_gardens_dashboard.dart';

class DashboardProvider extends ChangeNotifier {
  final GetGardensDashboard _getGardensDashboard;

  List<GardenDashboard> _gardens = [];
  bool _isLoading = true;
  String? _error;

  DashboardProvider(this._getGardensDashboard) {
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
      _gardens = await _getGardensDashboard();
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() => load();
}
