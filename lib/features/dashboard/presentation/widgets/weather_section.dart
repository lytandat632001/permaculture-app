// lib/features/dashboard/presentation/widgets/weather_section.dart

import 'package:flutter/material.dart';
import '../../domain/entities/weather_alert.dart';
import '../../domain/entities/weather_data.dart';
import '../../domain/entities/hourly_weather.dart';

class WeatherSection extends StatefulWidget {
  final WeatherData weather;
  final String cityName; // Truyền thêm tên thành phố từ bên ngoài

  const WeatherSection({
    super.key,
    required this.weather,
    required this.cityName,
  });

  @override
  State<WeatherSection> createState() => _WeatherSectionState();
}

class _WeatherSectionState extends State<WeatherSection> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToCurrentHour());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCurrentHour() {
    if (!_scrollController.hasClients) return;
    final nowHour = DateTime.now().hour;
    final items = widget.weather.hourly;
    int index = items.indexWhere((h) => h.time.hour == nowHour);
    if (index < 0) index = 0;
    const double itemWidth = 76.0;
    final double offset = (index * itemWidth).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
    _scrollController.jumpTo(offset);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.primaryContainer.withOpacity(0.25),
              colorScheme.surface,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ───── Hero Section mới theo hình mẫu ─────
            _HeroSection(weather: widget.weather, cityName: widget.cityName),
            const SizedBox(height: 16),

            // ───── Dự báo 24 giờ ─────
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Dự báo 24 giờ',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '← Vuốt xem',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 125,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: widget.weather.hourly.length,
                itemBuilder: (context, index) {
                  final HourlyWeather item = widget.weather.hourly[index];
                  final bool isNow = item.time.hour == DateTime.now().hour;
                  return Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Container(
                      width: 72,
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isNow
                            ? colorScheme.primary.withOpacity(0.35)
                            : colorScheme.surfaceContainerHighest.withOpacity(
                                0.3,
                              ),
                        borderRadius: BorderRadius.circular(12),
                        border: isNow
                            ? Border.all(color: colorScheme.primary, width: 2.5)
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${item.time.hour}:00',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isNow
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: isNow ? colorScheme.primary : null,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getWeatherEmoji(item.iconCode),
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${item.temperature.round()}°',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isNow ? colorScheme.primary : null,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.shortDescription,
                            style: TextStyle(
                              fontSize: 9,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // ───── Cảnh báo thời tiết (nếu có) ─────
            if (widget.weather.alerts.isNotEmpty) ...[
              const SizedBox(height: 16),
              _AlertBanner(alerts: widget.weather.alerts),
            ],
          ],
        ),
      ),
    );
  }

  String _getWeatherEmoji(String iconCode) {
    if (iconCode.startsWith('01')) return '☀️';
    if (iconCode.startsWith('02')) return '⛅';
    if (iconCode.startsWith('03') || iconCode.startsWith('04')) return '☁️';
    if (iconCode.startsWith('09') || iconCode.startsWith('10')) return '🌧️';
    if (iconCode.startsWith('11')) return '⚡';
    if (iconCode.startsWith('13')) return '❄️';
    if (iconCode.startsWith('50')) return '🌫️';
    return '🌤️';
  }
}

// ────────────────────────────────────────────────────────
// Hero Section (Đã bố trí lại giống hình mẫu)
// ────────────────────────────────────────────────────────
class _HeroSection extends StatelessWidget {
  final WeatherData weather;
  final String cityName;

  const _HeroSection({required this.weather, required this.cityName});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(14),
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
          // Cột bên trái: Vị trí -> Nhiệt độ lớn -> Mô tả & Thông số nhỏ
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Vị trí ở trên cùng
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

                // 2. Hàng chứa nhiệt độ to và thông số thu nhỏ bên phải
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${weather.currentTemperature.round()}°',
                      style: textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                        height: 1.0,
                        fontSize: 42,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            weather.currentDescription,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          // Dòng thông số nhỏ: Độ ẩm, Gió, Mưa
                          Text(
                            '💧 ${weather.humidity}%   🍃 ${weather.windSpeed.toStringAsFixed(1)} m/s',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Ô hiển thị Icon to ở bên phải giống hình
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: colorScheme.surface.withOpacity(0.6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorScheme.outlineVariant.withOpacity(0.3),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _getWeatherEmoji(weather.currentIcon),
                  style: const TextStyle(fontSize: 38),
                ),
                const SizedBox(height: 4),
                Text(
                  '${weather.currentTemperature.round()}°C',
                  style: textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getWeatherEmoji(String iconCode) {
    if (iconCode.startsWith('01')) return '☀️';
    if (iconCode.startsWith('02')) return '⛅';
    if (iconCode.startsWith('03') || iconCode.startsWith('04')) return '☁️';
    if (iconCode.startsWith('09') || iconCode.startsWith('10')) return '🌧️';
    if (iconCode.startsWith('11')) return '⚡';
    if (iconCode.startsWith('13')) return '❄️';
    if (iconCode.startsWith('50')) return '🌫️';
    return '🌤️';
  }
}

// ────────────────────────────────────────────────────────
// Alert Banner
// ────────────────────────────────────────────────────────
class _AlertBanner extends StatelessWidget {
  final List<WeatherAlert> alerts;
  const _AlertBanner({required this.alerts});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final filtered = alerts
        .where(
          (a) =>
              a.type == 'rain' ||
              a.type == 'wind' ||
              a.message.contains('mưa') ||
              a.message.contains('gió'),
        )
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
