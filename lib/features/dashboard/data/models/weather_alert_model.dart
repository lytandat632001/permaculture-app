import '../../domain/entities/weather_alert.dart';

class WeatherAlertModel extends WeatherAlert {
  const WeatherAlertModel({
    required super.type,
    required super.severity,
    required super.message,
  });

  factory WeatherAlertModel.fromJson(Map<String, dynamic> json) {
    return WeatherAlertModel(
      type: json['type'] as String,
      severity: json['severity'] as String,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'severity': severity,
    'message': message,
  };
}
