import '../../domain/entities/event_summary.dart';

class UpcomingEventModel extends UpcomingEvent {
  const UpcomingEventModel({
    required super.id,
    required super.title,
    required super.type,
    required super.date,
  });

  factory UpcomingEventModel.fromJson(Map<String, dynamic> json) {
    return UpcomingEventModel(
      id: json['id'] as String,
      title: json['title'] as String,
      type: json['type'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'type': type,
    'date': date.toIso8601String(),
  };
}

class EventSummaryModel extends EventSummary {
  const EventSummaryModel({required super.upcomingEvents});

  factory EventSummaryModel.fromJson(Map<String, dynamic> json) {
    return EventSummaryModel(
      upcomingEvents: (json['upcomingEvents'] as List<dynamic>)
          .map((e) => UpcomingEventModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'upcomingEvents': upcomingEvents.map((event) {
      return {
        'id': event.id,
        'title': event.title,
        'type': event.type,
        'date': event.date.toIso8601String(),
      };
    }).toList(),
  };
}
