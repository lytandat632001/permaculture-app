import '../entities/garden_dashboard.dart';
import '../repositories/dashboard_repository.dart';

class GetGardensDashboard {
  final DashboardRepository _repository;

  GetGardensDashboard(this._repository);

  Future<List<GardenDashboard>> call() async {
    return _repository.getGardensDashboard();
  }
}
