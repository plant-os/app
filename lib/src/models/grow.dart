class LocalDate {
  int year;
  int month;
  int day;

  LocalDate({
    required this.year,
    required this.month,
    required this.day,
  });
}

class Grow {
  // The firebase document id for this grow.
  String? id;
  String name;
  String? programId;
  String? deviceId;
  int? plot;
  String state; // "active" | "inactive"
  LocalDate? startDate;
  String? companyId;

  factory Grow.initial() {
    return Grow(
      id: null,
      name: "",
      programId: null,
      deviceId: null,
      plot: null,
      state: "active",
      startDate: null,
      companyId: null,
    );
  }

  Grow({
    required this.id,
    required this.name,
    required this.programId,
    required this.deviceId,
    required this.plot,
    required this.state,
    required this.startDate,
    required this.companyId,
  });

  Grow copyWith({
    String? id,
    String? name,
    String? programId,
    String? deviceId,
    int? plot,
    String? state,
    LocalDate? startDate,
    String? companyId,
  }) =>
      Grow(
        id: id ?? this.id,
        name: name ?? this.name,
        programId: programId ?? this.programId,
        deviceId: deviceId ?? this.deviceId,
        plot: plot ?? this.plot,
        state: state ?? this.state,
        startDate: startDate ?? this.startDate,
        companyId: companyId ?? this.companyId,
      );
}
