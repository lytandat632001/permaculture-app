import 'package:flutter/material.dart';
import '../../domain/entities/device_summary.dart';

class DeviceSection extends StatelessWidget {
  final DeviceSummary deviceSummary;

  const DeviceSection({super.key, required this.deviceSummary});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.precision_manufacturing, size: 20),
            const SizedBox(width: 8),
            Text(
              'Thiết bị',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            _buildStat(context, 'Tổng', deviceSummary.total),
            _buildStat(context, 'Online', deviceSummary.online, Colors.green),
            _buildStat(context, 'Offline', deviceSummary.offline, Colors.red),
            _buildStat(
              context,
              'Đang chạy',
              deviceSummary.running,
              Colors.blue,
            ),
            _buildStat(
              context,
              'Chạy quá lâu',
              deviceSummary.runningTooLong,
              Colors.orange,
            ),
            _buildStat(
              context,
              'Mất kết nối lâu',
              deviceSummary.offlineTooLong,
              Colors.red,
            ),
            _buildStat(
              context,
              'Lỗi',
              deviceSummary.error,
              Colors.red.shade700,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.arrow_forward, size: 18),
            label: const Text('Xem thiết bị'),
          ),
        ),
      ],
    );
  }

  Widget _buildStat(
    BuildContext context,
    String label,
    int value, [
    Color? color,
  ]) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: (color ?? Theme.of(context).colorScheme.surfaceVariant)
            .withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(width: 4),
          Text('$value', style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
