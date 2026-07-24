class Alert {
  final String id;
  final String type; // 'sensor', 'device', 'task', 'event', 'weather'
  final String severity; // 'critical', 'warning', 'info'
  final String message;
  final DateTime timestamp;

  const Alert({
    required this.id,
    required this.type,
    required this.severity,
    required this.message,
    required this.timestamp,
  });
}

class AlertSummary {
  final List<Alert> alerts;

  const AlertSummary({required this.alerts});
}
