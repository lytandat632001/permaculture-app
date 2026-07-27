import '../entities/garden_dashboard.dart';
import '../entities/weather_data.dart';

abstract class DashboardRepository {
  Future<List<GardenDashboard>> getGardensDashboard();
  Future<WeatherData> getWeather(double lat, double lon);
}