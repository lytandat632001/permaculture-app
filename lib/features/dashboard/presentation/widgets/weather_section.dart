// lib/features/dashboard/presentation/widgets/weather_section.dart

import 'package:flutter/material.dart';
import 'package:permaculture_application/features/dashboard/data/utils/weather_emoji.dart';
import '../../domain/entities/weather_data.dart';
import '../../domain/entities/hourly_weather.dart';
import 'weather_hero_section.dart';
import 'weather_alert_banner.dart';

class WeatherSection extends StatefulWidget {
  final WeatherData weather;
  final String cityName;

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

  // Kích thước thực tế của một mục timeline (width + padding phải)
  static const double _itemWidth = 75.0;
  static const double _itemRightPadding = 4.0;
  static const double _itemTotalAdvance =
      _itemWidth + _itemRightPadding; // 79.0

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToCurrentHour());
  }

  @override
  void didUpdateWidget(WeatherSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Khi danh sách hourly thay đổi (dữ liệu thực được cập nhật),
    // cuộn về giờ hiện tại sau khi build xong.
    if (oldWidget.weather.hourly != widget.weather.hourly) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _scrollToCurrentHour(),
      );
    }
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
    final double offset = (index * _itemTotalAdvance).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
    _scrollController.jumpTo(offset);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final now = DateTime.now();
    final currentHourIndex = widget.weather.hourly.indexWhere(
      (h) => h.time.hour == now.hour,
    );
    final HourlyWeather currentHourData = currentHourIndex >= 0
        ? widget.weather.hourly[currentHourIndex]
        : widget.weather.hourly.first;

    // Debug (có thể xoá sau khi mọi thứ hoạt động ổn định)
    print('----- [DEBUG UI] -----');
    print('Hero iconCode: ${currentHourData.iconCode}');
    print('Hero shortDescription: ${currentHourData.shortDescription}');
    print('Hero temperature: ${currentHourData.temperature}');
    print('Hero emoji: ${getWeatherEmoji(currentHourData.iconCode)}');
    print(
      'Timeline first 3 iconCode: ${widget.weather.hourly.take(3).map((e) => e.iconCode).toList()}',
    );
    print(
      'Timeline first 3 shortDesc: ${widget.weather.hourly.take(3).map((e) => e.shortDescription).toList()}',
    );
    print(
      'Timeline first 3 emoji: ${widget.weather.hourly.take(3).map((e) => getWeatherEmoji(e.iconCode)).toList()}',
    );
    print('----------------------');
    print('Current hour precipitation: ${currentHourData.precipitation}');

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
            WeatherHeroSection(
              temperature: currentHourData.temperature,
              iconCode: currentHourData.iconCode,
              description: currentHourData.shortDescription,
              humidity: widget.weather.humidity,
              windSpeed: widget.weather.windSpeed,
              uvIndex: currentHourData.uvIndex,
              cityName: widget.cityName,
              precipitation: currentHourData.precipitation,
            ),
            const SizedBox(height: 16),
            // Dự báo 24 giờ
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
                  final bool isNow = index == currentHourIndex;
                  return Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Container(
                      width: _itemWidth, // sử dụng hằng số
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
                            getWeatherEmoji(item.iconCode),
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
                          if (item.precipitation > 0)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                '☔ ${item.precipitation.toStringAsFixed(1)}',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w500,
                                  color: isNow
                                      ? colorScheme.primary
                                      : Colors.blueGrey.shade600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
            if (widget.weather.alerts.isNotEmpty) ...[
              const SizedBox(height: 16),
              WeatherAlertBanner(alerts: widget.weather.alerts),
            ],
          ],
        ),
      ),
    );
  }
}
