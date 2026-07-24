import '../../domain/entities/task_summary.dart';

class ImportantTaskModel extends ImportantTask {
  const ImportantTaskModel({
    required super.id,
    required super.title,
    required super.dueDate,
    required super.priority,
  });

  factory ImportantTaskModel.fromJson(Map<String, dynamic> json) {
    return ImportantTaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      priority: json['priority'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'dueDate': dueDate.toIso8601String(),
    'priority': priority,
  };
}

class TaskSummaryModel extends TaskSummary {
  const TaskSummaryModel({
    required super.pending,
    required super.overdue,
    required super.completedToday,
    required super.importantTasks,
  });

  factory TaskSummaryModel.fromJson(Map<String, dynamic> json) {
    return TaskSummaryModel(
      pending: json['pending'] as int,
      overdue: json['overdue'] as int,
      completedToday: json['completedToday'] as int,
      importantTasks: (json['importantTasks'] as List<dynamic>)
          .map((e) => ImportantTaskModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'pending': pending,
    'overdue': overdue,
    'completedToday': completedToday,
    'importantTasks': importantTasks
        .map(
          (e) => {
            'id': e.id,
            'title': e.title,
            'dueDate': e.dueDate.toIso8601String(),
            'priority': e.priority,
          },
        )
        .toList(),
  };
}
