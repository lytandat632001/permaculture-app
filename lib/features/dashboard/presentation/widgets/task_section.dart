import 'package:flutter/material.dart';
import '../../domain/entities/task_summary.dart';

class TaskSection extends StatelessWidget {
  final TaskSummary taskSummary;

  const TaskSection({super.key, required this.taskSummary});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.checklist, size: 20),
            const SizedBox(width: 8),
            Text(
              'Công việc',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildChip(
              context,
              'Chưa hoàn thành',
              taskSummary.pending,
              Colors.orange,
            ),
            const SizedBox(width: 8),
            _buildChip(context, 'Quá hạn', taskSummary.overdue, Colors.red),
            const SizedBox(width: 8),
            _buildChip(
              context,
              'Hoàn thành hôm nay',
              taskSummary.completedToday,
              Colors.green,
            ),
          ],
        ),
        if (taskSummary.importantTasks.isNotEmpty) ...[
          const SizedBox(height: 8),
          ...taskSummary.importantTasks.map(
            (task) => ListTile(
              dense: true,
              leading: Icon(
                task.priority == 'high' ? Icons.priority_high : Icons.circle,
                color: task.priority == 'high' ? Colors.red : Colors.grey,
                size: 16,
              ),
              title: Text(
                task.title,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              trailing: Text(
                task.dueDate.isBefore(DateTime.now())
                    ? 'Quá hạn'
                    : '${task.dueDate.hour}h',
                style: TextStyle(
                  color: task.dueDate.isBefore(DateTime.now())
                      ? Colors.red
                      : null,
                ),
              ),
            ),
          ),
        ],
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.arrow_forward, size: 18),
            label: const Text('Xem công việc'),
          ),
        ),
      ],
    );
  }

  Widget _buildChip(
    BuildContext context,
    String label,
    int count,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label: $count',
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
