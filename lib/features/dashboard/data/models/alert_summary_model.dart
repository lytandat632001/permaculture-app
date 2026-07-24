import '../../domain/entities/alert_summary.dart';

class AlertModel extends Alert {
  const AlertModel({
    required super.id,
    required super.type,
    required super.severity,
    required super.message,
    required super.timestamp,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'] as String,
      type: json['type'] as String,
      severity: json['severity'] as String,
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'severity': severity,
    'message': message,
    'timestamp': timestamp.toIso8601String(),
  };
}

class AlertSummaryModel extends AlertSummary {
  const AlertSummaryModel({required super.alerts});

  factory AlertSummaryModel.fromJson(Map<String, dynamic> json) {
    return AlertSummaryModel(
      alerts: (json['alerts'] as List<dynamic>)
          .map((e) => AlertModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'alerts': alerts
        .map(
          (alert) => {
            'id': alert.id,
            'type': alert.type,
            'severity': alert.severity,
            'message': alert.message,
            'timestamp': alert.timestamp.toIso8601String(),
          },
        )
        .toList(),
  };
}
