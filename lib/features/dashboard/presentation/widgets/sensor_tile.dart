import 'package:flutter/material.dart';
import '../../domain/entities/sensor_summary.dart';

class SensorTile extends StatelessWidget {
  final SensorSummary sensor;

  const SensorTile({super.key, required this.sensor});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    IconData statusIcon;
    switch (sensor.status) {
      case 'critical':
        statusColor = Colors.red;
        statusIcon = Icons.error;
        break;
      case 'warning':
        statusColor = Colors.orange;
        statusIcon = Icons.warning_amber;
        break;
      default:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_sensorIcon(sensor.type), size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${sensor.value} ${sensor.unit}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(sensor.name, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          const SizedBox(width: 8),
          Icon(statusIcon, size: 16, color: statusColor),
        ],
      ),
    );
  }

  IconData _sensorIcon(String type) {
    switch (type) {
      case 'temperature':
        return Icons.thermostat;
      case 'humidity':
        return Icons.water_drop;
      case 'soil_moisture':
        return Icons.grain;
      case 'ph':
        return Icons.science;
      default:
        return Icons.sensors;
    }
  }
}
