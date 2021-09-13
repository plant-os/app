import 'dart:ui';

class Program {
  final String id;
  final String name;
  final String companyId;

  Program({
    required this.id,
    required this.name,
    required this.companyId,
  });

  Program.fromJson(String id, Map<String, dynamic> json)
      : id = id,
        name = json['Name'] ?? "",
        companyId = json['CompanyId'] ?? "";

  Map<String, dynamic> toJson() => {'Name': name, 'CompanyId': companyId};

  @override
  String toString() => "Program${toJson()}";

  @override
  bool operator ==(dynamic o) =>
      o is Program && o.id == id && o.name == name && o.companyId == companyId;

  @override
  int get hashCode => hashValues(id, name, companyId);
}
