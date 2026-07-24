class WeatherAlert {
  final String type; // 'storm', 'rain', 'heat', ...
  final String severity; // 'critical', 'warning', 'info'
  final String message;

  const WeatherAlert({
    required this.type,
    required this.severity,
    required this.message,
  });
}
