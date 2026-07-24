import '../../domain/entities/garden_dashboard.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_local_datasource.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardLocalDatasource _datasource;

  DashboardRepositoryImpl(this._datasource);

  @override
  Future<List<GardenDashboard>> getGardensDashboard() async {
    return _datasource.getGardensDashboard();
  }
}
