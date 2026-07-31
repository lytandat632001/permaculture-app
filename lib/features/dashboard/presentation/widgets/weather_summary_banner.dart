import 'package:flutter/material.dart';
import '../../data/utils/weather_emoji.dart';
import '../../domain/entities/hourly_weather.dart';

class WeatherSummaryBanner extends StatelessWidget {
  final List<HourlyWeather> hourly;
  final int currentIndex;
  final double? currentWindSpeed; // ✅ thêm

  const WeatherSummaryBanner({
    super.key,
    required this.hourly,
    required this.currentIndex,
    this.currentWindSpeed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (hourly.isEmpty) return const SizedBox.shrink();

    final periods = _getThreePeriods();
    if (periods.isEmpty) {
      return _buildEmptyState(colorScheme);
    }

    final isAnyCritical = periods.any(_isCritical);
    final alertColor = isAnyCritical ? colorScheme.error : colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: alertColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isAnyCritical
                    ? Icons.warning_amber_rounded
                    : Icons.info_outline,
                size: 18,
                color: alertColor,
              ),
              const SizedBox(width: 8),
              Text(
                isAnyCritical ? '⚠️ CẢNH BÁO THỜI TIẾT' : 'THÔNG BÁO THỜI TIẾT',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: alertColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...List.generate(periods.length, (i) {
            final label = ['Hiện tại:', '3 giờ nữa:', '6 giờ nữa:'][i];
            final data = periods[i];
            final isNow = label == 'Hiện tại:';
            final windSpeedToUse = isNow && currentWindSpeed != null
                ? currentWindSpeed
                : data.windSpeed;
            return _buildAlertLine(
              label: label,
              data: data,
              windSpeedToUse: windSpeedToUse,
              isCritical: _isCritical(data),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: colorScheme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Không đủ dữ liệu dự báo cho các mốc thời gian',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertLine({
    required String label,
    required HourlyWeather data,
    required double? windSpeedToUse,
    required bool isCritical,
  }) {
    final textStyle = TextStyle(
      fontSize: 12,
      fontWeight: isCritical ? FontWeight.w700 : FontWeight.w500,
      color: isCritical ? Colors.red.shade700 : null,
    );

    String desc = data.shortDescription.isNotEmpty
        ? data.shortDescription
        : _describeWeatherByIcon(data.iconCode);

    String wind = (windSpeedToUse ?? 0) > 0
        ? 'gió ${windSpeedToUse!.toStringAsFixed(1)}km/h'
        : 'gió nhẹ';

    String rain = data.precipitation > 0
        ? '☔${data.precipitation.toStringAsFixed(1)}mm'
        : '';

    String temp = '${data.temperature.round()}°C';

    List<String> parts = [desc, wind];
    if (rain.isNotEmpty) parts.add(rain);
    parts.add(temp);

    String content = parts.join(', ');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isCritical ? Colors.red.shade700 : null,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(content, style: textStyle)),
        ],
      ),
    );
  }

  List<HourlyWeather> _getThreePeriods() {
    final now = DateTime.now();
    final currentHour = now.hour;
    final hasEnoughData = hourly.length >= 48;
    final List<HourlyWeather> result = [];

    for (int offset in [0, 3, 6]) {
      int idx = -1;
      if (hasEnoughData) {
        idx = currentIndex + offset;
        if (idx >= hourly.length) continue;
      } else {
        final targetHour = (currentHour + offset) % 24;
        idx = hourly.indexWhere((h) => h.time.hour == targetHour);
        if (idx == -1) {
          if (currentIndex + offset < hourly.length) {
            idx = currentIndex + offset;
          } else {
            continue;
          }
        }
      }
      result.add(hourly[idx]);
    }
    return result;
  }

  bool _isCritical(HourlyWeather data) {
    return data.precipitation > 10.0 || (data.windSpeed ?? 0) > 30.0;
  }

  String _describeWeatherByIcon(String iconCode) {
    switch (iconCode) {
      case '01d':
      case '01n':
        return 'Trời nắng';
      case '02d':
      case '02n':
        return 'Có mây nhẹ';
      case '03d':
      case '03n':
        return 'Mây rải rác';
      case '04d':
      case '04n':
        return 'Nhiều mây';
      case '09d':
      case '09n':
        return 'Mưa rào';
      case '10d':
      case '10n':
        return 'Mưa';
      case '11d':
      case '11n':
        return 'Mưa dông';
      case '13d':
      case '13n':
        return 'Tuyết';
      case '50d':
      case '50n':
        return 'Sương mù';
      default:
        return 'Thời tiết bất thường';
    }
  }
}
