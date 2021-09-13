import 'dart:ui';

import 'package:plantos/src/models/company.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final Company? company;
  final Dashboard? dashboard;
  final Role? role;

  UserModel(
      this.id, this.name, this.company, this.dashboard, this.email, this.role);

  UserModel.fromJson(Map<String, dynamic> json)
      : name = json['Name'] ?? null,
        id = json['Id'] ?? null,
        company =
            json['Company'] != null ? Company.fromJson(json['Company']) : null,
        dashboard = json['Dashboard'] != null
            ? Dashboard.fromJson(json['Dashboard'])
            : null,
        role = json['Role'] != null ? Role.fromJson(json["Role"]) : null,
        email = json['Email'] ?? null;

  Map<String, dynamic> toJson() => {
        'Name': name,
        'Id': id,
        'Company': company!.toJson(),
        'Dashboard': dashboard!.toJson(),
        'Role': role!.toJson(),
        'Email': email
      };

  @override
  String toString() {
    return "UserModel ${toJson()}";
  }

  @override
  bool operator ==(dynamic o) =>
      o is UserModel &&
      o.name == name &&
      o.id == id &&
      o.company == company &&
      o.dashboard == dashboard &&
      o.role == role &&
      o.email == email;

  @override
  int get hashCode => hashValues(name, id, company, dashboard, role, email);
}

class Dashboard {
  final bool fertigation;
  final bool indoor;
  final bool outdoor;

  Dashboard.fromJson(Map<String, dynamic> json)
      : fertigation = json['Fertigation'] ?? null,
        indoor = json['Indoor'] ?? null,
        outdoor = json['Outdoor'] ?? null;

  Map<String, dynamic> toJson() =>
      {'Fertigation': fertigation, 'Indoor': indoor, 'Outdoor': outdoor};

  Dashboard(this.fertigation, this.indoor, this.outdoor);
}

class Role {
  final bool admin;
  final bool owner;
  final bool worker;

  Role.fromJson(Map<String, dynamic> json)
      : admin = json['Admin'] ?? null,
        worker = json['Worker'] ?? null,
        owner = json['Owner'] ?? null;

  Map<String, dynamic> toJson() =>
      {'Admin': admin, 'Worker': worker, 'Owner': owner};

  Role(this.admin, this.owner, this.worker);
}
