import '../entities/weather_data.dart';
import '../repositories/dashboard_repository.dart';

class GetGardenWeather {
  final DashboardRepository _repository;

  GetGardenWeather(this._repository);

  Future<WeatherData> call(double lat, double lon) async {
    return _repository.getWeather(lat, lon);
  }
}