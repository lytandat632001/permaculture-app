import 'package:flutter/material.dart';
import '../../domain/entities/weather_data.dart';
import 'weather_timeline.dart';

class WeatherSection extends StatelessWidget {
  final WeatherData weather;

  const WeatherSection({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.wb_sunny, color: Colors.orange, size: 32),
            const SizedBox(width: 8),
            Text(
              '${weather.currentTemperature.toStringAsFixed(1)}°C',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(width: 8),
            Text(
              weather.currentDescription,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Spacer(),
            Column(
              children: [
                Text(
                  '💧 ${weather.humidity}%',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  '🌬 ${weather.windSpeed} m/s',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  '☀ UV ${weather.uvIndex}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        WeatherTimeline(hourly: weather.hourly),
        if (weather.alerts.isNotEmpty) ...[
          const SizedBox(height: 8),
          ...weather.alerts.map(
            (alert) => Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: alert.severity == 'critical'
                    ? Colors.red.shade50
                    : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    alert.severity == 'critical' ? Icons.warning : Icons.info,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      alert.message,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
