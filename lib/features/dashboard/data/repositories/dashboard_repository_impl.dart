// lib/features/dashboard/data/repositories/dashboard_repository_impl.dart
import '../../domain/entities/garden_dashboard.dart';
import '../../domain/entities/weather_data.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_local_datasource.dart';
import '../datasources/weather_remote_datasource.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardLocalDatasource _localDatasource;
  final WeatherRemoteDatasource _weatherDatasource;

  DashboardRepositoryImpl({
    required DashboardLocalDatasource localDatasource,
    required WeatherRemoteDatasource weatherDatasource,
  })  : _localDatasource = localDatasource,
        _weatherDatasource = weatherDatasource;

  @override
  Future<List<GardenDashboard>> getGardensDashboard() async {
    return _localDatasource.getGardensDashboard();
  }

  @override
  Future<WeatherData> getWeather(double lat, double lon) async {
    return _weatherDatasource.getWeather(latitude: lat, longitude: lon);
  }
}