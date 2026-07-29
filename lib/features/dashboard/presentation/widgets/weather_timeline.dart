// lib/features/dashboard/presentation/widgets/weather_timeline.dart

import 'package:flutter/material.dart';
import '../../domain/entities/hourly_weather.dart';
import '../../data/utils/weather_emoji.dart';

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
      height: 130,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: hourly.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = hourly[index];
          final bool isNow = index == currentHourIndex;

          // Debug precipitation
          debugPrint('Hour ${item.time.hour}: precip=${item.precipitation}');

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 75,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${item.time.hour}h',
                  style: textTheme.labelSmall?.copyWith(
                    fontWeight: isNow ? FontWeight.bold : FontWeight.normal,
                    color: isNow
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  getWeatherEmoji(item.iconCode),
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.temperature.toStringAsFixed(0)}°',
                  style: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isNow ? colorScheme.primary : colorScheme.onSurface,
                  ),
                ),
                // Mô tả ngắn
                if (item.shortDescription.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      item.shortDescription,
                      style: textTheme.labelSmall?.copyWith(
                        fontSize: 8,
                        color: isNow
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
