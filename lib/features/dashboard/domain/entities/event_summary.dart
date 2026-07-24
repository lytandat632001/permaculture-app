class UpcomingEvent {
  final String id;
  final String title;
  final String type; // 'harvest', 'fertilize', 'prune', 'plant'
  final DateTime date;

  const UpcomingEvent({
    required this.id,
    required this.title,
    required this.type,
    required this.date,
  });
}

class EventSummary {
  final List<UpcomingEvent> upcomingEvents;

  const EventSummary({required this.upcomingEvents});
}
