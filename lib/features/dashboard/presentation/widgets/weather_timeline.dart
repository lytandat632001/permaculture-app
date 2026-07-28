// lib/features/dashboard/presentation/widgets/weather_timeline.dart

import 'package:flutter/material.dart';
import '../../domain/entities/hourly_weather.dart';

class WeatherTimeline extends StatelessWidget {
  final List<HourlyWeather> hourly;

  const WeatherTimeline({super.key, required this.hourly});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final now = DateTime.now();
    final currentHourIndex = hourly.indexWhere((h) => h.time.hour == now.hour);

    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: hourly.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = hourly[index];
          final bool isNow = index == currentHourIndex;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 72,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            decoration: BoxDecoration(
              color: isNow
                  ? colorScheme.primaryContainer
                  : colorScheme.surfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
              border: isNow
                  ? Border.all(color: colorScheme.primary, width: 2)
                  : null,
              boxShadow: isNow
                  ? [
                      BoxShadow(
                        color: colorScheme.primary.withOpacity(0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${item.time.hour}h',
                  style: textTheme.labelSmall?.copyWith(
                    fontWeight: isNow ? FontWeight.bold : FontWeight.normal,
                    color: isNow ? colorScheme.primary : colorScheme.onSurfaceVariant,
                  ),
                ),
                Icon(
                  _mapTimelineIcon(item.iconCode),
                  size: 30,
                  color: isNow ? colorScheme.primary : colorScheme.onSurface,
                ),
                Text(
                  '${item.temperature.toStringAsFixed(0)}°',
                  style: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isNow ? colorScheme.primary : colorScheme.onSurface,
                  ),
                ),
                if (item.shortDescription.isNotEmpty)
                  Text(
                    item.shortDescription,
                    style: textTheme.labelSmall?.copyWith(
                      fontSize: 9,
                      color: isNow ? colorScheme.primary : colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _mapTimelineIcon(String code) {
    if (code.contains('01')) return Icons.wb_sunny;
    if (code.contains('02') || code.contains('03')) return Icons.cloud;
    if (code.contains('09') || code.contains('10') || code.contains('11')) {
      return Icons.water_drop;
    }
    if (code.contains('13')) return Icons.ac_unit;
    return Icons.cloud_queue;
  }
}