// lib/features/dashboard/domain/entities/hourly_weather.dart
class HourlyWeather {
  final DateTime time;
  final String iconCode;
  final double temperature;
  final String shortDescription;
  final double precipitation;
  final int uvIndex;
  final double? windSpeed; // km/h

  const HourlyWeather({
    required this.time,
    required this.iconCode,
    required this.temperature,
    required this.shortDescription,
    this.precipitation = 0.0,
    this.uvIndex = 0,
    this.windSpeed,
  });
}
