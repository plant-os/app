class Program {
  final String id;
  final String name;

  Program(this.id, this.name);

  Program.fromJson(String id, Map<String, dynamic> json)
      : id = id,
        name = json['Name'] ?? null;

  Map<String, dynamic> toJson() => {'Name': name};

  @override
  String toString() {
    return "Program ${toJson()}";
  }

  // ignore: hash_and_equals
  @override
  bool operator ==(dynamic o) => o is Program && o.id == id && o.name == name;
}
