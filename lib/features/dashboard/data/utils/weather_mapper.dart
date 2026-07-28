// ---------------------------------------------------------
// Detailed weather info mapping (based on WMO Weather codes)
// ---------------------------------------------------------

class WeatherInfo {
  final String icon;           // Open‑Meteo icon code, e.g. '01d'
  final String shortDescription; // Vietnamese short text
  final String description;      // Vietnamese full description

  const WeatherInfo({
    required this.icon,
    required this.shortDescription,
    required this.description,
  });
}

WeatherInfo getWeatherInfo(int code) {
  switch (code) {
    // Clear
    case 0:
      return const WeatherInfo(
        icon: '01d',
        shortDescription: 'Quang đãng',
        description: 'Bầu trời trong xanh, không có mây',
      );
    case 1:
      return const WeatherInfo(
        icon: '02d',
        shortDescription: 'Ít mây',
        description: 'Chủ yếu quang đãng',
      );
    case 2:
      return const WeatherInfo(
        icon: '03d',
        shortDescription: 'Mây rải rác',
        description: 'Có mây một phần',
      );
    case 3:
      return const WeatherInfo(
        icon: '04d',
        shortDescription: 'Nhiều mây',
        description: 'Bầu trời nhiều mây',
      );
    // Fog
    case 45:
      return const WeatherInfo(
        icon: '50d',
        shortDescription: 'Sương mù',
        description: 'Có sương mù',
      );
    case 48:
      return const WeatherInfo(
        icon: '50d',
        shortDescription: 'Sương mù',
        description: 'Sương mù đóng băng',
      );
    // Drizzle
    case 51:
      return const WeatherInfo(
        icon: '09d',
        shortDescription: 'Mưa phùn nhẹ',
        description: 'Mưa phùn nhẹ',
      );
    case 53:
      return const WeatherInfo(
        icon: '09d',
        shortDescription: 'Mưa phùn',
        description: 'Mưa phùn vừa',
      );
    case 55:
      return const WeatherInfo(
        icon: '09d',
        shortDescription: 'Mưa phùn dày',
        description: 'Mưa phùn dày',
      );
    case 56:
      return const WeatherInfo(
        icon: '09d',
        shortDescription: 'Mưa phùn lạnh',
        description: 'Mưa phùn đóng băng nhẹ',
      );
    case 57:
      return const WeatherInfo(
        icon: '09d',
        shortDescription: 'Mưa phùn lạnh',
        description: 'Mưa phùn đóng băng dày',
      );
    // Rain
    case 61:
      return const WeatherInfo(
        icon: '10d',
        shortDescription: 'Mưa nhẹ',
        description: 'Mưa nhẹ',
      );
    case 63:
      return const WeatherInfo(
        icon: '10d',
        shortDescription: 'Mưa vừa',
        description: 'Mưa vừa',
      );
    case 65:
      return const WeatherInfo(
        icon: '10d',
        shortDescription: 'Mưa lớn',
        description: 'Mưa lớn',
      );
    case 66:
      return const WeatherInfo(
        icon: '10d',
        shortDescription: 'Mưa đóng băng',
        description: 'Mưa đóng băng nhẹ',
      );
    case 67:
      return const WeatherInfo(
        icon: '10d',
        shortDescription: 'Mưa đóng băng',
        description: 'Mưa đóng băng lớn',
      );
    // Snow
    case 71:
      return const WeatherInfo(
        icon: '13d',
        shortDescription: 'Tuyết nhẹ',
        description: 'Tuyết rơi nhẹ',
      );
    case 73:
      return const WeatherInfo(
        icon: '13d',
        shortDescription: 'Tuyết vừa',
        description: 'Tuyết rơi vừa',
      );
    case 75:
      return const WeatherInfo(
        icon: '13d',
        shortDescription: 'Tuyết dày',
        description: 'Tuyết rơi dày',
      );
    case 77:
      return const WeatherInfo(
        icon: '13d',
        shortDescription: 'Hạt tuyết',
        description: 'Tuyết dạng hạt',
      );
    // Rain shower
    case 80:
      return const WeatherInfo(
        icon: '09d',
        shortDescription: 'Mưa rào nhẹ',
        description: 'Mưa rào nhẹ',
      );
    case 81:
      return const WeatherInfo(
        icon: '09d',
        shortDescription: 'Mưa rào',
        description: 'Mưa rào vừa',
      );
    case 82:
      return const WeatherInfo(
        icon: '09d',
        shortDescription: 'Mưa rào lớn',
        description: 'Mưa rào rất lớn',
      );
    // Snow shower
    case 85:
      return const WeatherInfo(
        icon: '13d',
        shortDescription: 'Mưa tuyết nhẹ',
        description: 'Mưa tuyết nhẹ',
      );
    case 86:
      return const WeatherInfo(
        icon: '13d',
        shortDescription: 'Mưa tuyết lớn',
        description: 'Mưa tuyết lớn',
      );
    // Thunderstorm
    case 95:
      return const WeatherInfo(
        icon: '11d',
        shortDescription: 'Giông',
        description: 'Có giông',
      );
    case 96:
      return const WeatherInfo(
        icon: '11d',
        shortDescription: 'Giông mưa đá',
        description: 'Giông kèm mưa đá nhẹ',
      );
    case 99:
      return const WeatherInfo(
        icon: '11d',
        shortDescription: 'Giông dữ dội',
        description: 'Giông kèm mưa đá lớn',
      );
    default:
      return const WeatherInfo(
        icon: '03d',
        shortDescription: 'Không xác định',
        description: 'Không có thông tin thời tiết',
      );
  }
}

// ---------------------------------------------------------
// Helper functions used by the datasource – they now
// delegate to the detailed WeatherInfo.
// ---------------------------------------------------------

/// Returns the icon code for a given WMO weather code.
String getWeatherIcon(int weatherCode) {
  return getWeatherInfo(weatherCode).icon;
}

/// Returns a short Vietnamese description.
String getWeatherShortDescription(int weatherCode) {
  return getWeatherInfo(weatherCode).shortDescription;
}

/// Returns a full Vietnamese description.
String getWeatherDescription(int weatherCode) {
  return getWeatherInfo(weatherCode).description;
}

/// Generates weather alerts from raw hourly data (unchanged logic).
List<Map<String, String>> generateWeatherAlerts({
  required List<int> weatherCodes,
  required List<double> precipitation,
  required List<double> windSpeed,
  required List<double> uvIndex,
  required List<double> temperature,
}) {
  final alerts = <Map<String, String>>[];
  final now = DateTime.now();
  for (int i = 0; i < weatherCodes.length && i < 24; i++) {
    final code = weatherCodes[i];
    final rain = precipitation[i];
    final wind = windSpeed[i];
    final uv = uvIndex[i];
    final temp = temperature[i];

    if (code >= 60 || rain > 5.0) {
      alerts.add({
        'type': 'rain',
        'severity': 'warning',
        'message': 'Mưa lớn dự kiến lúc ${now.add(Duration(hours: i)).hour}:00',
      });
    }
    if (uv >= 8) {
      alerts.add({
        'type': 'uv',
        'severity': 'warning',
        'message': 'UV cao (${uv.toInt()}) vào buổi trưa',
      });
    }
    if (wind >= 10.0) {
      alerts.add({
        'type': 'wind',
        'severity': 'warning',
        'message': 'Gió mạnh ${wind.toStringAsFixed(1)} m/s',
      });
    }
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