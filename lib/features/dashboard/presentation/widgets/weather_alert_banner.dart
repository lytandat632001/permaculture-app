// lib/features/dashboard/presentation/widgets/weather_alert_banner.dart

import 'package:flutter/material.dart';
import '../../domain/entities/weather_alert.dart';

class WeatherAlertBanner extends StatelessWidget {
  final List<WeatherAlert> alerts;

  const WeatherAlertBanner({super.key, required this.alerts});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // Lấy tối đa 2 cảnh báo mưa/gió để gộp
    final filtered = alerts
        .where((a) =>
            a.type == 'rain' ||
            a.type == 'wind' ||
            a.message.contains('mưa') ||
            a.message.contains('gió'))
        .take(2)
        .toList();
    if (filtered.isEmpty) return const SizedBox.shrink();

    final message = filtered.length == 2
        ? '${filtered[0].message} – ${filtered[1].message}'
        : filtered.first.message;
    final isCritical = filtered.any((a) => a.severity == 'critical');
    final alertColor = isCritical ? colorScheme.error : colorScheme.tertiary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: alertColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: alertColor.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Icon(
            isCritical ? Icons.warning_amber_rounded : Icons.info_outline,
            size: 20,
            color: alertColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: alertColor,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}