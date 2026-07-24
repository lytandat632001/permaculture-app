import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  final String userName;
  final int gardenCount;
  final int alertCount;

  const DashboardHeader({
    super.key,
    required this.userName,
    required this.gardenCount,
    required this.alertCount,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final months = [
      'tháng 1',
      'tháng 2',
      'tháng 3',
      'tháng 4',
      'tháng 5',
      'tháng 6',
      'tháng 7',
      'tháng 8',
      'tháng 9',
      'tháng 10',
      'tháng 11',
      'tháng 12',
    ];
    final dateStr =
        'Hôm nay, ngày ${now.day} ${months[now.month - 1]}, ${now.year}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Xin chào, $userName',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      dateStr,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Badge(
                  isLabelVisible: alertCount > 0,
                  label: Text(alertCount.toString()),
                  child: Icon(Icons.notifications_outlined),
                ),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildInfoChip(context, Icons.yard, '$gardenCount khu vườn'),
              const SizedBox(width: 12),
              _buildInfoChip(
                context,
                Icons.warning_amber_rounded,
                '$alertCount cảnh báo',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 6),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
