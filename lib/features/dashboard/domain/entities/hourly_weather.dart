class HourlyWeather {
  final DateTime time;
  final String iconCode; // '01d', '02d', ...
  final double temperature;
  final String shortDescription;

  const HourlyWeather({
    required this.time,
    required this.iconCode,
    required this.temperature,
    required this.shortDescription,
  });
}
