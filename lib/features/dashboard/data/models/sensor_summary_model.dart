import '../../domain/entities/sensor_summary.dart';

class SensorSummaryModel extends SensorSummary {
  const SensorSummaryModel({
    required super.id,
    required super.name,
    required super.type,
    required super.value,
    required super.unit,
    required super.status,
  });

  factory SensorSummaryModel.fromJson(Map<String, dynamic> json) {
    return SensorSummaryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      value: (json['value'] as num).toDouble(),
      unit: json['unit'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'value': value,
    'unit': unit,
    'status': status,
  };
}
