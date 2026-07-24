class SensorSummary {
  final String id;
  final String name;
  final String
  type; // 'temperature', 'humidity', 'soil_moisture', 'ph', 'light', 'co2', 'rain', 'wind'
  final double value;
  final String unit;
  final String status; // 'normal', 'warning', 'critical'

  const SensorSummary({
    required this.id,
    required this.name,
    required this.type,
    required this.value,
    required this.unit,
    required this.status,
  });
}
