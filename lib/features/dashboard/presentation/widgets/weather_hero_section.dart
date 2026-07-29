import 'package:flutter/material.dart';
import 'package:permaculture_application/features/dashboard/data/utils/weather_emoji.dart';

class WeatherHeroSection extends StatelessWidget {
  final double temperature;
  final String iconCode;
  final String description;
  final int humidity;
  final double windSpeed;
  final int uvIndex;
  final String cityName;
  final double precipitation;

  const WeatherHeroSection({
    super.key,
    required this.temperature,
    required this.iconCode,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.uvIndex,
    required this.cityName,
    this.precipitation = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Cột bên trái: thông tin thời tiết
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Địa điểm
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 14,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        cityName,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // Nhiệt độ + mô tả + chỉ số
                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // ← căn giữa theo dọc
                  children: [
                    // Nhiệt độ lớn
                    Text(
                      '${temperature.round()}°',
                      style: textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                        fontSize: 30,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Mô tả và các thông số phụ
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            description,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          // Dòng 1: Độ ẩm và Gió
                          Row(
                            children: [
                              _buildMetric('💧', '$humidity%'),
                              const SizedBox(width: 8),
                              _buildMetric(
                                '💨',
                                '${windSpeed.toStringAsFixed(1)} km/h',
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          // Dòng 2: UV và Lượng mưa
                          Row(
                            children: [
                              _buildMetric('☀️', 'UV $uvIndex'),
                              if (precipitation > 0) ...[
                                const SizedBox(width: 8),
                                _buildMetric(
                                  '☔',
                                  '${precipitation.toStringAsFixed(1)} mm',
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Ô icon bên phải
          Container(
            width: 60,
            height: 85,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primaryContainer.withOpacity(0.8),
                  colorScheme.primaryContainer.withOpacity(0.4),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
              border: Border.all(
                color: colorScheme.primary.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    getWeatherEmoji(iconCode),
                    style: const TextStyle(fontSize: 30),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${temperature.round()}°C',
                    style: textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(icon, style: const TextStyle(fontSize: 12)),
        const SizedBox(width: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
