import 'package:flutter/material.dart';
import '../../domain/entities/event_summary.dart';

class EventSection extends StatelessWidget {
  final EventSummary eventSummary;

  const EventSection({super.key, required this.eventSummary});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.event, size: 20),
            const SizedBox(width: 8),
            Text(
              'Sự kiện',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (eventSummary.upcomingEvents.isEmpty)
          Text(
            'Không có sự kiện sắp tới',
            style: Theme.of(context).textTheme.bodySmall,
          )
        else
          ...eventSummary.upcomingEvents.map((event) {
            final daysLeft = event.date.difference(DateTime.now()).inDays;
            return ListTile(
              dense: true,
              leading: Icon(_eventIcon(event.type), size: 24),
              title: Text(event.title),
              trailing: Text(
                daysLeft == 0 ? 'Hôm nay' : 'Còn $daysLeft ngày',
                style: TextStyle(color: daysLeft <= 1 ? Colors.orange : null),
              ),
            );
          }),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.arrow_forward, size: 18),
            label: const Text('Xem lịch'),
          ),
        ),
      ],
    );
  }

  IconData _eventIcon(String type) {
    switch (type) {
      case 'harvest':
        return Icons.agriculture;
      case 'fertilize':
        return Icons.science;
      case 'prune':
        return Icons.cut;
      case 'plant':
        return Icons.yard;
      default:
        return Icons.event;
    }
  }
}
