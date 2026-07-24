import 'package:flutter/material.dart';
import '../../domain/entities/garden_dashboard.dart';
import 'garden_header.dart';
import 'weather_section.dart';
import 'sensor_section.dart';
import 'device_section.dart';
import 'task_section.dart';
import 'event_section.dart';
import 'alert_section.dart';
import 'quick_action_section.dart';

class GardenDashboardCard extends StatelessWidget {
  final GardenDashboard garden;

  const GardenDashboardCard({super.key, required this.garden});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GardenHeader(info: garden.info),
            const Divider(height: 24),
            WeatherSection(weather: garden.weather),
            const Divider(height: 24),
            SensorSection(sensors: garden.sensors),
            const Divider(height: 24),
            DeviceSection(deviceSummary: garden.deviceSummary),
            const Divider(height: 24),
            TaskSection(taskSummary: garden.taskSummary),
            const Divider(height: 24),
            EventSection(eventSummary: garden.eventSummary),
            const Divider(height: 24),
            AlertSection(alertSummary: garden.alertSummary),
            const Divider(height: 24),
            QuickActionSection(gardenId: garden.info.id),
          ],
        ),
      ),
    );
  }
}
