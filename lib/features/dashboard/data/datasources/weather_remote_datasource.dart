// lib/features/dashboard/data/datasources/weather_remote_datasource.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_data_model.dart';
import '../models/hourly_weather_model.dart';
import '../models/weather_alert_model.dart';
import '../utils/weather_mapper.dart';

class WeatherRemoteDatasource {
  final http.Client client;

  WeatherRemoteDatasource({required this.client});

  Future<WeatherDataModel> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    final url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast'
      '?latitude=$latitude&longitude=$longitude'
      '&current_weather=true'
      '&hourly=temperature_2m,relative_humidity_2m,weather_code,precipitation,wind_speed_10m,uv_index'
      '&timezone=auto&forecast_days=1',
    );

    final response = await client.get(url);
    if (response.statusCode != 200) {
      throw Exception('Không thể tải thời tiết: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    // Current weather
    final currentWeather = json['current_weather'] as Map<String, dynamic>;
    final currentWeatherCode = currentWeather['weather_code'] as int;
    final currentTemp = (currentWeather['temperature'] as num).toDouble();

    // Hourly
    final hourlyData = json['hourly'] as Map<String, dynamic>;
    final times = (hourlyData['time'] as List<dynamic>).cast<String>();
    final temperatures = (hourlyData['temperature_2m'] as List<dynamic>).cast<num>();
    final humidityList = (hourlyData['relative_humidity_2m'] as List<dynamic>).cast<num>();
    final weatherCodes = (hourlyData['weather_code'] as List<dynamic>).cast<int>();
    final precipitation = (hourlyData['precipitation'] as List<dynamic>).cast<num>();
    final windSpeed = (hourlyData['wind_speed_10m'] as List<dynamic>).cast<num>();
    final uvIndex = (hourlyData['uv_index'] as List<dynamic>).cast<num>();

    final hourlyList = <HourlyWeatherModel>[];
    for (int i = 0; i < times.length; i++) {
      hourlyList.add(HourlyWeatherModel(
        time: DateTime.parse(times[i]),
        iconCode: getWeatherIcon(weatherCodes[i]),
        temperature: temperatures[i].toDouble(),
        shortDescription: getWeatherShortDescription(weatherCodes[i]),
      ));
    }

    final currentHumidity = humidityList.isNotEmpty ? humidityList[0].toInt() : 0;
    final currentWindSpeed = windSpeed.isNotEmpty ? windSpeed[0].toDouble() : 0.0;
    final currentUv = uvIndex.isNotEmpty ? uvIndex[0].toInt() : 0;

    final alertMaps = generateWeatherAlerts(
      weatherCodes: weatherCodes,
      precipitation: precipitation.cast<double>(),
      windSpeed: windSpeed.cast<double>(),
      uvIndex: uvIndex.cast<double>(),
      temperature: temperatures.cast<double>(),
    );
    final alerts = alertMaps.map((m) => WeatherAlertModel(
          type: m['type']!,
          severity: m['severity']!,
          message: m['message']!,
        )).toList();

    return WeatherDataModel(
      currentIcon: getWeatherIcon(currentWeatherCode),
      currentTemperature: currentTemp,
      currentDescription: getWeatherDescription(currentWeatherCode),
      humidity: currentHumidity,
      windSpeed: currentWindSpeed,
      uvIndex: currentUv,
      hourly: hourlyList,
      alerts: alerts,
    );
  }
}