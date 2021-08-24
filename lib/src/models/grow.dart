class LocalDate {
  final int year;
  final int month;
  final int day;

  LocalDate({
    required this.year,
    required this.month,
    required this.day,
  });
}

class Grow {
  // The firebase document id for this grow.
  final String id;
  final String name;
  final String programId;
  final String deviceId;
  final int plot;
  final String state; // "active" | "inactive"
  final LocalDate startDate;

  Grow({
    required this.id,
    required this.name,
    required this.programId,
    required this.deviceId,
    required this.plot,
    required this.state,
    required this.startDate,
  });
}
