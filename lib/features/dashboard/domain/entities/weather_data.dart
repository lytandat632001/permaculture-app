import 'hourly_weather.dart';
import 'weather_alert.dart';

class WeatherData {
  final String currentIcon;
  final double currentTemperature;
  final String currentDescription;
  final int humidity;
  final double windSpeed;
  final int uvIndex;
  final List<HourlyWeather> hourly;
  final List<WeatherAlert> alerts;

  const WeatherData({
    required this.currentIcon,
    required this.currentTemperature,
    required this.currentDescription,
    required this.humidity,
    required this.windSpeed,
    required this.uvIndex,
    required this.hourly,
    required this.alerts,
  });
}
