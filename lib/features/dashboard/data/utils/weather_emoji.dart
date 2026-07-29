// lib/features/dashboard/data/utils/weather_emoji.dart

/// Trả về emoji tương ứng với icon code từ Open‑Meteo (ví dụ: '01d', '09d', v.v.)
/// Sử dụng startsWith để ánh xạ chính xác mọi tiền tố.
String getWeatherEmoji(String iconCode) {
  if (iconCode.startsWith('01')) {
    return '☀️'; // Trời quang
  } else if (iconCode.startsWith('02')) {
    return '⛅'; // Ít mây
  } else if (iconCode.startsWith('03') || iconCode.startsWith('04')) {
    return '☁️'; // Nhiều mây / u ám
  } else if (iconCode.startsWith('09') || iconCode.startsWith('10')) {
    return '🌧️'; // Mưa (mưa phùn, mưa rào, mưa lớn…)
  } else if (iconCode.startsWith('11')) {
    return '⛈️'; // Giông bão
  } else if (iconCode.startsWith('13')) {
    return '❄️'; // Tuyết
  } else if (iconCode.startsWith('50')) {
    return '🌫️'; // Sương mù
  } else {
    return '🌤️'; // Biểu tượng mặc định (có mây và mặt trời)
  }
}
