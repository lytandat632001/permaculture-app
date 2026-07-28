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
    print('🌤 [Weather API] Gọi URL: $url');
    print('🌤 [Weather API] Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      print(
        '🌤 [Weather API] Dữ liệu trả về (200 ký tự đầu): ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}',
      );
    } else {
      print('🌤 [Weather API] Lỗi: ${response.body}');
    }

    if (response.statusCode != 200) {
      throw Exception('Không thể tải thời tiết: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    // Current weather (có thể null nếu API lỗi, nhưng thường có)
    final currentWeather = json['current_weather'] as Map<String, dynamic>?;
    final currentWeatherCode = (currentWeather?['weather_code'] as int?) ?? 0;
    final currentTemp =
        (currentWeather?['temperature'] as num?)?.toDouble() ?? 0.0;

    // Hourly
    final hourlyData = json['hourly'] as Map<String, dynamic>?;
    if (hourlyData == null) {
      throw Exception('Không có dữ liệu hourly');
    }

    // Lấy các list raw, cho phép null bên trong
    final timesRaw = (hourlyData['time'] as List<dynamic>?) ?? [];
    final temperaturesRaw =
        (hourlyData['temperature_2m'] as List<dynamic>?) ?? [];
    final humiditiesRaw =
        (hourlyData['relative_humidity_2m'] as List<dynamic>?) ?? [];
    final weatherCodesRaw =
        (hourlyData['weather_code'] as List<dynamic>?) ?? [];
    final precipitationsRaw =
        (hourlyData['precipitation'] as List<dynamic>?) ?? [];
    final windSpeedsRaw =
        (hourlyData['wind_speed_10m'] as List<dynamic>?) ?? [];
    final uvIndicesRaw = (hourlyData['uv_index'] as List<dynamic>?) ?? [];

    final hourlyList = <HourlyWeatherModel>[];
    final length = timesRaw.length;

    // Tạo các list an toàn (thay null bằng giá trị mặc định)
    final times = timesRaw.map((e) => e.toString()).toList();
    final temperatures = temperaturesRaw
        .map((e) => (e as num?)?.toDouble() ?? 0.0)
        .toList();
    final humidities = humiditiesRaw
        .map((e) => (e as num?)?.toInt() ?? 0)
        .toList();
    final weatherCodes = weatherCodesRaw.map((e) => (e as int?) ?? 0).toList();
    final precipitations = precipitationsRaw
        .map((e) => (e as num?)?.toDouble() ?? 0.0)
        .toList();
    final windSpeeds = windSpeedsRaw
        .map((e) => (e as num?)?.toDouble() ?? 0.0)
        .toList();
    final uvIndices = uvIndicesRaw
        .map((e) => (e as num?)?.toInt() ?? 0)
        .toList();

    for (int i = 0; i < length; i++) {
      hourlyList.add(
        HourlyWeatherModel(
          time: DateTime.parse(times[i]),
          iconCode: getWeatherIcon(weatherCodes[i]),
          temperature: temperatures[i],
          shortDescription: getWeatherShortDescription(weatherCodes[i]),
        ),
      );
    }

    // Lấy thông số hiện tại từ giờ đầu tiên (nếu có)
    final currentHumidity = humidities.isNotEmpty ? humidities[0] : 0;
    final currentWindSpeed = windSpeeds.isNotEmpty ? windSpeeds[0] : 0.0;
    final currentUv = uvIndices.isNotEmpty ? uvIndices[0] : 0;

    // Tạo alerts từ dữ liệu đã làm sạch
    final alertMaps = generateWeatherAlerts(
      weatherCodes: weatherCodes,
      precipitation: precipitations,
      windSpeed: windSpeeds,
      uvIndex: uvIndices.map((e) => e.toDouble()).toList(),
      temperature: temperatures,
    );
    final alerts = alertMaps
        .map(
          (m) => WeatherAlertModel(
            type: m['type']!,
            severity: m['severity']!,
            message: m['message']!,
          ),
        )
        .toList();

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
