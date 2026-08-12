class Plant {
  final String id;
  final String gardenId;
  final String name;
  final String? species;
  final DateTime? plantingDate;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Plant({
    required this.id,
    required this.gardenId,
    required this.name,
    this.species,
    this.plantingDate,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
}