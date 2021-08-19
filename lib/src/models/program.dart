class Program {
  final String id;
  final String name;
  final String companyId;

  Program(this.id, this.name, this.companyId);

  Program.fromJson(String id, Map<String, dynamic> json)
      : id = id,
        name = json['Name'] ?? "",
        companyId = json['CompanyId'] ?? "";

  Map<String, dynamic> toJson() => {'Name': name, 'CompanyId': companyId};

  @override
  String toString() {
    return "Program{${toJson()}}";
  }

  // ignore: hash_and_equals
  @override
  bool operator ==(dynamic o) =>
      o is Program && o.id == id && o.name == name && o.companyId == companyId;
}
