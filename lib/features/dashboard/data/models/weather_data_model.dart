import '../../domain/entities/weather_data.dart';
import 'hourly_weather_model.dart';
import 'weather_alert_model.dart';

class WeatherDataModel extends WeatherData {
  const WeatherDataModel({
    required super.currentIcon,
    required super.currentTemperature,
    required super.currentDescription,
    required super.humidity,
    required super.windSpeed,
    required super.uvIndex,
    required super.hourly,
    required super.alerts,
  });

  factory WeatherDataModel.fromJson(Map<String, dynamic> json) {
    return WeatherDataModel(
      currentIcon: json['currentIcon'] as String,
      currentTemperature: (json['currentTemperature'] as num).toDouble(),
      currentDescription: json['currentDescription'] as String,
      humidity: json['humidity'] as int,
      windSpeed: (json['windSpeed'] as num).toDouble(),
      uvIndex: json['uvIndex'] as int,
      hourly: (json['hourly'] as List<dynamic>)
          .map((e) => HourlyWeatherModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      alerts: (json['alerts'] as List<dynamic>)
          .map((e) => WeatherAlertModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'currentIcon': currentIcon,
    'currentTemperature': currentTemperature,
    'currentDescription': currentDescription,
    'humidity': humidity,
    'windSpeed': windSpeed,
    'uvIndex': uvIndex,
    'hourly': hourly.map((item) {
      return {
        'time': item.time.toIso8601String(),
        'iconCode': item.iconCode,
        'temperature': item.temperature,
        'shortDescription': item.shortDescription,
      };
    }).toList(),
    'alerts': alerts.map((alert) {
      return {
        'type': alert.type,
        'severity': alert.severity,
        'message': alert.message,
      };
    }).toList(),
  };
}
