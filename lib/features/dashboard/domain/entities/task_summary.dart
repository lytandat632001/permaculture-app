class ImportantTask {
  final String id;
  final String title;
  final DateTime dueDate;
  final String priority; // 'high', 'medium', 'low'

  const ImportantTask({
    required this.id,
    required this.title,
    required this.dueDate,
    required this.priority,
  });
}

class TaskSummary {
  final int pending;
  final int overdue;
  final int completedToday;
  final List<ImportantTask> importantTasks; // max 3

  const TaskSummary({
    required this.pending,
    required this.overdue,
    required this.completedToday,
    required this.importantTasks,
  });
}
