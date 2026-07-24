import 'package:flutter/material.dart';

class QuickActionSection extends StatelessWidget {
  final String gardenId;

  const QuickActionSection({super.key, required this.gardenId});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _Action(Icons.info_outline, 'Chi tiết'),
      _Action(Icons.sensors, 'Sensor'),
      _Action(Icons.precision_manufacturing, 'Thiết bị'),
      _Action(Icons.checklist, 'Công việc'),
      _Action(Icons.event, 'Sự kiện'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Truy cập nhanh',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: actions
              .map(
                (action) => InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${action.label} - Vườn $gardenId'),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(action.icon, size: 18),
                        const SizedBox(width: 6),
                        Text(action.label),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _Action {
  final IconData icon;
  final String label;
  const _Action(this.icon, this.label);
}
