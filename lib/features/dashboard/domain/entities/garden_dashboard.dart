import 'garden_info.dart';
import 'weather_data.dart';
import 'sensor_summary.dart';
import 'device_summary.dart';
import 'task_summary.dart';
import 'event_summary.dart';
import 'alert_summary.dart';

class GardenDashboard {
  final GardenInfo info;
  final WeatherData weather;
  final List<SensorSummary> sensors;
  final DeviceSummary deviceSummary;
  final TaskSummary taskSummary;
  final EventSummary eventSummary;
  final AlertSummary alertSummary;

  const GardenDashboard({
    required this.info,
    required this.weather,
    required this.sensors,
    required this.deviceSummary,
    required this.taskSummary,
    required this.eventSummary,
    required this.alertSummary,
  });
}
