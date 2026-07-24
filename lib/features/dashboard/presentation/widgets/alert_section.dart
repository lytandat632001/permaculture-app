import 'package:flutter/material.dart';
import '../../domain/entities/alert_summary.dart';

class AlertSection extends StatelessWidget {
  final AlertSummary alertSummary;

  const AlertSection({super.key, required this.alertSummary});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.warning_amber_rounded, size: 20),
            const SizedBox(width: 8),
            Text(
              'Cảnh báo',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (alertSummary.alerts.isEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 20),
                SizedBox(width: 8),
                Text(
                  'Không có cảnh báo',
                  style: TextStyle(color: Colors.green),
                ),
              ],
            ),
          )
        else
          ...alertSummary.alerts.map((alert) {
            Color color;
            switch (alert.severity) {
              case 'critical':
                color = Colors.red;
                break;
              case 'warning':
                color = Colors.orange;
                break;
              default:
                color = Colors.blue;
                break;
            }
            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    alert.severity == 'critical'
                        ? Icons.error
                        : Icons.warning_amber,
                    color: color,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(alert.message, style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }
}
