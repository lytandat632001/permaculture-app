import 'package:flutter/material.dart';
import '../../domain/entities/hourly_weather.dart';

class WeatherTimeline extends StatelessWidget {
  final List<HourlyWeather> hourly;

  const WeatherTimeline({super.key, required this.hourly});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: hourly.length,
        separatorBuilder: (_, __) => const VerticalDivider(width: 16),
        itemBuilder: (context, index) {
          final item = hourly[index];
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${item.time.hour}h',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Icon(_mapIcon(item.iconCode), size: 24),
              Text(
                '${item.temperature.toStringAsFixed(0)}°',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          );
        },
      ),
    );
  }

  IconData _mapIcon(String code) {
    if (code.contains('01')) return Icons.wb_sunny;
    if (code.contains('02') || code.contains('03')) return Icons.cloud;
    if (code.contains('09') || code.contains('10')) return Icons.grain; // mưa
    return Icons.cloud_queue;
  }
}
