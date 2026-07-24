import 'package:flutter/material.dart';
import '../../domain/entities/sensor_summary.dart';
import 'sensor_tile.dart';

class SensorSection extends StatelessWidget {
  final List<SensorSummary> sensors;

  const SensorSection({super.key, required this.sensors});

  @override
  Widget build(BuildContext context) {
    if (sensors.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.sensors, size: 20),
            const SizedBox(width: 8),
            Text(
              'Cảm biến',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: sensors.map((s) => SensorTile(sensor: s)).toList(),
        ),
      ],
    );
  }
}
