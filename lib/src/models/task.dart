class Task {
  final String id;
  final String name;

  Task(this.id, this.name);

  Task.fromJson(String id, Map<String, dynamic> json)
      : id = id,
        name = json['Name'] ?? null;

  Map<String, dynamic> toJson() => {'Name': name};

  @override
  String toString() {
    return "Task ${toJson()}";
  }

  // ignore: hash_and_equals
  @override
  bool operator ==(dynamic o) => o is Task && o.id == id && o.name == name;
}
