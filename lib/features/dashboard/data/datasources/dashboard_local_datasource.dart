import '../../domain/entities/garden_dashboard.dart';
import '../../domain/entities/garden_info.dart';
import '../../domain/entities/weather_data.dart';
import '../../domain/entities/hourly_weather.dart';
import '../../domain/entities/weather_alert.dart';
import '../../domain/entities/sensor_summary.dart';
import '../../domain/entities/device_summary.dart';
import '../../domain/entities/task_summary.dart';
import '../../domain/entities/event_summary.dart';
import '../../domain/entities/alert_summary.dart';

class DashboardLocalDatasource {
  Future<List<GardenDashboard>> getGardensDashboard() async {
    await Future.delayed(const Duration(milliseconds: 1000)); // giả lập network

    final now = DateTime.now();
    final hourly = List.generate(24, (i) {
      final hour = DateTime(now.year, now.month, now.day, i);
      return HourlyWeather(
        time: hour,
        iconCode: i < 6 ? '01n' : (i < 12 ? '02d' : (i < 18 ? '03d' : '04d')),
        temperature: 25.0 + (i < 12 ? i * 0.5 : (24 - i) * 0.6),
        shortDescription: i < 6
            ? 'Quang đãng'
            : (i < 12 ? 'Nắng nhẹ' : 'Nhiều mây'),
      );
    });

    final garden1 = GardenDashboard(
      info: GardenInfo(
        id: 'g1',
        name: 'Vườn Cacao',
        imageUrl:
            'https://images.unsplash.com/photo-1501004318641-b39e6451bec6?w=400',
        location: 'Định Quán - Đồng Nai',
        status: 'active',
        area: 2500,
      ),
      weather: WeatherData(
        currentIcon: '02d',
        currentTemperature: 31.0,
        currentDescription: 'Nắng nhẹ',
        humidity: 71,
        windSpeed: 3.5,
        uvIndex: 6,
        hourly: hourly,
        alerts: [
          WeatherAlert(
            type: 'rain',
            severity: 'warning',
            message: '3 giờ nữa: Mưa vừa (80%)',
          ),
          WeatherAlert(
            type: 'rain',
            severity: 'info',
            message: '24 giờ tới: Có mưa lúc 15:00',
          ),
        ],
      ),
      sensors: [
        SensorSummary(
          id: 's1',
          name: 'Nhiệt độ',
          type: 'temperature',
          value: 30.5,
          unit: '°C',
          status: 'normal',
        ),
        SensorSummary(
          id: 's2',
          name: 'Độ ẩm KK',
          type: 'humidity',
          value: 71,
          unit: '%',
          status: 'normal',
        ),
        SensorSummary(
          id: 's3',
          name: 'Độ ẩm đất',
          type: 'soil_moisture',
          value: 26,
          unit: '%',
          status: 'critical',
        ),
        SensorSummary(
          id: 's4',
          name: 'pH',
          type: 'ph',
          value: 5.4,
          unit: '',
          status: 'warning',
        ),
      ],
      deviceSummary: DeviceSummary(
        total: 9,
        online: 8,
        offline: 1,
        running: 3,
        runningTooLong: 2,
        offlineTooLong: 1,
        error: 0,
      ),
      taskSummary: TaskSummary(
        pending: 2,
        overdue: 1,
        completedToday: 5,
        importantTasks: [
          ImportantTask(
            id: 't1',
            title: 'Tưới khu B',
            dueDate: now.add(const Duration(hours: 2)),
            priority: 'high',
          ),
          ImportantTask(
            id: 't2',
            title: 'Kiểm tra máy bơm',
            dueDate: now.add(const Duration(hours: 3)),
            priority: 'medium',
          ),
        ],
      ),
      eventSummary: EventSummary(
        upcomingEvents: [
          UpcomingEvent(
            id: 'e1',
            title: 'Thu hoạch',
            type: 'harvest',
            date: now.add(const Duration(days: 3)),
          ),
          UpcomingEvent(
            id: 'e2',
            title: 'Bón phân',
            type: 'fertilize',
            date: now.add(const Duration(days: 5)),
          ),
          UpcomingEvent(
            id: 'e3',
            title: 'Cắt tỉa',
            type: 'prune',
            date: now.add(const Duration(days: 7)),
          ),
        ],
      ),
      alertSummary: AlertSummary(
        alerts: [
          Alert(
            id: 'a1',
            type: 'sensor',
            severity: 'critical',
            message: 'Độ ẩm đất quá thấp',
            timestamp: now.subtract(const Duration(minutes: 30)),
          ),
          Alert(
            id: 'a2',
            type: 'weather',
            severity: 'warning',
            message: 'Mưa lớn sau 3 giờ',
            timestamp: now.subtract(const Duration(hours: 1)),
          ),
          Alert(
            id: 'a3',
            type: 'event',
            severity: 'info',
            message: 'Đến lịch bón phân',
            timestamp: now.subtract(const Duration(hours: 2)),
          ),
        ],
      ),
    );

    final garden2 = GardenDashboard(
      info: GardenInfo(
        id: 'g2',
        name: 'Vườn Rau Organic',
        imageUrl:
            'https://images.unsplash.com/photo-1523348837708-15d4a09cfac2?w=400',
        location: 'Đà Lạt - Lâm Đồng',
        status: 'active',
        area: 800,
      ),
      weather: WeatherData(
        currentIcon: '03d',
        currentTemperature: 22.0,
        currentDescription: 'Nhiều mây',
        humidity: 85,
        windSpeed: 2.0,
        uvIndex: 3,
        hourly: List.generate(24, (i) {
          final hour = DateTime(now.year, now.month, now.day, i);
          return HourlyWeather(
            time: hour,
            iconCode: i < 10 ? '03d' : '09d',
            temperature: 20.0 + (i < 12 ? i * 0.3 : (24 - i) * 0.2),
            shortDescription: i < 10 ? 'Nhiều mây' : 'Mưa nhỏ',
          );
        }),
        alerts: [
          WeatherAlert(
            type: 'rain',
            severity: 'warning',
            message: 'Mưa kéo dài đến chiều',
          ),
        ],
      ),
      sensors: [
        SensorSummary(
          id: 's5',
          name: 'Nhiệt độ',
          type: 'temperature',
          value: 22.0,
          unit: '°C',
          status: 'normal',
        ),
        SensorSummary(
          id: 's6',
          name: 'Độ ẩm KK',
          type: 'humidity',
          value: 85,
          unit: '%',
          status: 'normal',
        ),
        SensorSummary(
          id: 's7',
          name: 'Độ ẩm đất',
          type: 'soil_moisture',
          value: 45,
          unit: '%',
          status: 'normal',
        ),
      ],
      deviceSummary: DeviceSummary(
        total: 5,
        online: 5,
        offline: 0,
        running: 2,
        runningTooLong: 0,
        offlineTooLong: 0,
        error: 0,
      ),
      taskSummary: TaskSummary(
        pending: 1,
        overdue: 0,
        completedToday: 8,
        importantTasks: [
          ImportantTask(
            id: 't3',
            title: 'Tưới rau',
            dueDate: now.add(const Duration(hours: 1)),
            priority: 'medium',
          ),
        ],
      ),
      eventSummary: EventSummary(
        upcomingEvents: [
          UpcomingEvent(
            id: 'e4',
            title: 'Thu hoạch xà lách',
            type: 'harvest',
            date: now.add(const Duration(days: 2)),
          ),
        ],
      ),
      alertSummary: AlertSummary(alerts: []),
    );

    final garden3 = GardenDashboard(
      info: GardenInfo(
        id: 'g3',
        name: 'Vườn Cây Ăn Trái',
        imageUrl:
            'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=400',
        location: 'Củ Chi - TP.HCM',
        status: 'active',
        area: 5000,
      ),
      weather: WeatherData(
        currentIcon: '01d',
        currentTemperature: 34.0,
        currentDescription: 'Trời quang',
        humidity: 60,
        windSpeed: 4.0,
        uvIndex: 9,
        hourly: List.generate(24, (i) {
          final hour = DateTime(now.year, now.month, now.day, i);
          return HourlyWeather(
            time: hour,
            iconCode: i < 16 ? '01d' : '01n',
            temperature: 28.0 + (i < 14 ? i * 0.4 : (24 - i) * 0.3),
            shortDescription: 'Trời quang',
          );
        }),
        alerts: [
          WeatherAlert(
            type: 'uv',
            severity: 'warning',
            message: 'UV cao (9), hạn chế ra ngoài',
          ),
        ],
      ),
      sensors: [
        SensorSummary(
          id: 's8',
          name: 'Nhiệt độ',
          type: 'temperature',
          value: 34.0,
          unit: '°C',
          status: 'warning',
        ),
        SensorSummary(
          id: 's9',
          name: 'Độ ẩm KK',
          type: 'humidity',
          value: 60,
          unit: '%',
          status: 'normal',
        ),
        SensorSummary(
          id: 's10',
          name: 'Ánh sáng',
          type: 'light',
          value: 85000,
          unit: 'lux',
          status: 'normal',
        ),
      ],
      deviceSummary: DeviceSummary(
        total: 12,
        online: 11,
        offline: 1,
        running: 5,
        runningTooLong: 1,
        offlineTooLong: 0,
        error: 1,
      ),
      taskSummary: TaskSummary(
        pending: 4,
        overdue: 2,
        completedToday: 3,
        importantTasks: [
          ImportantTask(
            id: 't4',
            title: 'Tưới cây ăn trái',
            dueDate: now.subtract(const Duration(hours: 1)),
            priority: 'high',
          ),
          ImportantTask(
            id: 't5',
            title: 'Kiểm tra hệ thống tưới',
            dueDate: now.add(const Duration(hours: 2)),
            priority: 'high',
          ),
        ],
      ),
      eventSummary: EventSummary(
        upcomingEvents: [
          UpcomingEvent(
            id: 'e5',
            title: 'Bón phân NPK',
            type: 'fertilize',
            date: now.add(const Duration(days: 4)),
          ),
          UpcomingEvent(
            id: 'e6',
            title: 'Cắt tỉa cành',
            type: 'prune',
            date: now.add(const Duration(days: 10)),
          ),
        ],
      ),
      alertSummary: AlertSummary(
        alerts: [
          Alert(
            id: 'a4',
            type: 'device',
            severity: 'critical',
            message: 'Thiết bị bơm #3 lỗi',
            timestamp: now.subtract(const Duration(hours: 1)),
          ),
          Alert(
            id: 'a5',
            type: 'sensor',
            severity: 'warning',
            message: 'Nhiệt độ vượt ngưỡng',
            timestamp: now.subtract(const Duration(minutes: 45)),
          ),
        ],
      ),
    );

    return [garden1, garden2, garden3];
  }
}
