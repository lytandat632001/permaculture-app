import '../entities/garden_dashboard.dart';

abstract class DashboardRepository {
  Future<List<GardenDashboard>> getGardensDashboard();
}
