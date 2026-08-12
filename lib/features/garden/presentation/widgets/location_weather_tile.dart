import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permaculture_application/features/dashboard/data/datasources/weather_remote_datasource.dart';
import 'package:permaculture_application/features/dashboard/data/utils/weather_emoji.dart';

class LocationWeatherTile extends StatefulWidget {
  final double latitude;
  final double longitude;

  const LocationWeatherTile({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<LocationWeatherTile> createState() => _LocationWeatherTileState();
}

class _LocationWeatherTileState extends State<LocationWeatherTile> {
  String _temp = '--°';
  String _icon = '🌤️';
  String _desc = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    try {
      final datasource = WeatherRemoteDatasource(client: http.Client());
      final weather = await datasource.getWeather(
        latitude: widget.latitude,
        longitude: widget.longitude,
      );
      if (mounted) {
        setState(() {
          _temp = '${weather.currentTemperature.round()}°C';
          _icon = getWeatherEmoji(weather.currentIcon);
          _desc = weather.currentDescription;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _desc = 'Không có dữ liệu';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const SizedBox(
        width: 60,
        height: 40,
        child: Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))),
      );
    }
    return Column(
      children: [
        Text(_icon, style: const TextStyle(fontSize: 24)),
        Text(_temp, style: Theme.of(context).textTheme.labelSmall),
        if (_desc.isNotEmpty)
          Text(_desc, style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 9, color: Colors.grey)),
      ],
    );
  }
}