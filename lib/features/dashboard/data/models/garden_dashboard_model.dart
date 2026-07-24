import '../../domain/entities/garden_dashboard.dart';
import 'garden_info_model.dart';
import 'weather_data_model.dart';
import 'sensor_summary_model.dart';
import 'device_summary_model.dart';
import 'task_summary_model.dart';
import 'event_summary_model.dart';
import 'alert_summary_model.dart';

class GardenDashboardModel extends GardenDashboard {
  const GardenDashboardModel({
    required super.info,
    required super.weather,
    required super.sensors,
    required super.deviceSummary,
    required super.taskSummary,
    required super.eventSummary,
    required super.alertSummary,
  });

  factory GardenDashboardModel.fromJson(Map<String, dynamic> json) {
    return GardenDashboardModel(
      info: GardenInfoModel.fromJson(json['info'] as Map<String, dynamic>),
      weather: WeatherDataModel.fromJson(
        json['weather'] as Map<String, dynamic>,
      ),
      sensors: (json['sensors'] as List<dynamic>)
          .map((e) => SensorSummaryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      deviceSummary: DeviceSummaryModel.fromJson(
        json['deviceSummary'] as Map<String, dynamic>,
      ),
      taskSummary: TaskSummaryModel.fromJson(
        json['taskSummary'] as Map<String, dynamic>,
      ),
      eventSummary: EventSummaryModel.fromJson(
        json['eventSummary'] as Map<String, dynamic>,
      ),
      alertSummary: AlertSummaryModel.fromJson(
        json['alertSummary'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'info': {
      'id': info.id,
      'name': info.name,
      'imageUrl': info.imageUrl,
      'location': info.location,
      'status': info.status,
      'area': info.area,
    },
    'weather': {
      'currentIcon': weather.currentIcon,
      'currentTemperature': weather.currentTemperature,
      'currentDescription': weather.currentDescription,
      'humidity': weather.humidity,
      'windSpeed': weather.windSpeed,
      'uvIndex': weather.uvIndex,
      'hourly': weather.hourly.map((item) {
        return {
          'time': item.time.toIso8601String(),
          'iconCode': item.iconCode,
          'temperature': item.temperature,
          'shortDescription': item.shortDescription,
        };
      }).toList(),
      'alerts': weather.alerts.map((alert) {
        return {
          'type': alert.type,
          'severity': alert.severity,
          'message': alert.message,
        };
      }).toList(),
    },
    'sensors': sensors.map((s) {
      return {
        'id': s.id,
        'name': s.name,
        'type': s.type,
        'value': s.value,
        'unit': s.unit,
        'status': s.status,
      };
    }).toList(),
    'deviceSummary': {
      'total': deviceSummary.total,
      'online': deviceSummary.online,
      'offline': deviceSummary.offline,
      'running': deviceSummary.running,
      'runningTooLong': deviceSummary.runningTooLong,
      'offlineTooLong': deviceSummary.offlineTooLong,
      'error': deviceSummary.error,
    },
    'taskSummary': {
      'pending': taskSummary.pending,
      'overdue': taskSummary.overdue,
      'completedToday': taskSummary.completedToday,
      'importantTasks': taskSummary.importantTasks.map((task) {
        return {
          'id': task.id,
          'title': task.title,
          'dueDate': task.dueDate.toIso8601String(),
          'priority': task.priority,
        };
      }).toList(),
    },
    'eventSummary': {
      'upcomingEvents': eventSummary.upcomingEvents.map((event) {
        return {
          'id': event.id,
          'title': event.title,
          'type': event.type,
          'date': event.date.toIso8601String(),
        };
      }).toList(),
    },
    'alertSummary': {
      'alerts': alertSummary.alerts.map((alert) {
        return {
          'id': alert.id,
          'type': alert.type,
          'severity': alert.severity,
          'message': alert.message,
          'timestamp': alert.timestamp.toIso8601String(),
        };
      }).toList(),
    },
  };
}
