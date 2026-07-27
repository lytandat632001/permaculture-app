// lib/features/dashboard/data/utils/weather_mapper.dart

/// Trả về icon Material tương ứng với weather_code của Open-Meteo
String getWeatherIcon(int weatherCode) {
  if (weatherCode <= 1) return '01d'; // quang đãng
  if (weatherCode <= 3) return '02d'; // ít mây
  if (weatherCode <= 48) return '03d'; // mây mù
  if (weatherCode <= 57) return '09d'; // mưa phùn
  if (weatherCode <= 67) return '10d'; // mưa
  if (weatherCode <= 77) return '13d'; // tuyết
  if (weatherCode <= 82) return '11d'; // giông
  return '04d'; // nhiều mây
}

/// Trả về mô tả ngắn (tiếng Việt)
String getWeatherShortDescription(int weatherCode) {
  if (weatherCode <= 1) return 'Quang đãng';
  if (weatherCode <= 3) return 'Ít mây';
  if (weatherCode <= 48) return 'Mây mù';
  if (weatherCode <= 57) return 'Mưa phùn';
  if (weatherCode <= 67) return 'Mưa';
  if (weatherCode <= 77) return 'Tuyết';
  if (weatherCode <= 82) return 'Giông';
  return 'Nhiều mây';
}

/// Trả về mô tả đầy đủ hơn
String getWeatherDescription(int weatherCode) {
  if (weatherCode <= 1) return 'Trời quang';
  if (weatherCode <= 3) return 'Trời nhiều mây';
  if (weatherCode <= 48) return 'Sương mù';
  if (weatherCode <= 57) return 'Mưa phùn';
  if (weatherCode <= 67) return 'Mưa rào';
  if (weatherCode <= 77) return 'Tuyết rơi';
  if (weatherCode <= 82) return 'Mưa giông';
  return 'Trời nhiều mây';
}

/// Phân tích dữ liệu API để tạo danh sách cảnh báo thời tiết
List<Map<String, String>> generateWeatherAlerts({
  required List<int> weatherCodes,
  required List<double> precipitation,
  required List<double> windSpeed,
  required List<double> uvIndex,
  required List<double> temperature,
}) {
  final alerts = <Map<String, String>>[];
  final now = DateTime.now();
  // Kiểm tra trong 24h tới
  for (int i = 0; i < weatherCodes.length && i < 24; i++) {
    final code = weatherCodes[i];
    final rain = precipitation[i];
    final wind = windSpeed[i];
    final uv = uvIndex[i];
    final temp = temperature[i];

    // Mưa lớn (code >= 60 hoặc precipitation > 5mm)
    if (code >= 60 || rain > 5.0) {
      alerts.add({
        'type': 'rain',
        'severity': 'warning',
        'message': 'Mưa lớn dự kiến lúc ${now.add(Duration(hours: i)).hour}:00',
      });
    }
    // UV cao
    if (uv >= 8) {
      alerts.add({
        'type': 'uv',
        'severity': 'warning',
        'message': 'Chỉ số UV cao (${uv.toInt()}) vào buổi trưa',
      });
    }
    // Gió mạnh
    if (wind >= 10.0) {
      alerts.add({
        'type': 'wind',
        'severity': 'warning',
        'message': 'Gió mạnh ${wind.toStringAsFixed(1)} m/s dự kiến',
      });
    }
    // Nhiệt độ cao
    if (temp >= 37) {
      alerts.add({
        'type': 'heat',
        'severity': 'warning',
        'message': 'Nắng nóng ${temp.toStringAsFixed(1)}°C',
      });
    }
  }
  return alerts;
}