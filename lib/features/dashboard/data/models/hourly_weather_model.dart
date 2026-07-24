import '../../domain/entities/hourly_weather.dart';

class HourlyWeatherModel extends HourlyWeather {
  const HourlyWeatherModel({
    required super.time,
    required super.iconCode,
    required super.temperature,
    required super.shortDescription,
  });

  factory HourlyWeatherModel.fromJson(Map<String, dynamic> json) {
    return HourlyWeatherModel(
      time: DateTime.parse(json['time'] as String),
      iconCode: json['iconCode'] as String,
      temperature: (json['temperature'] as num).toDouble(),
      shortDescription: json['shortDescription'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'time': time.toIso8601String(),
    'iconCode': iconCode,
    'temperature': temperature,
    'shortDescription': shortDescription,
  };
}
