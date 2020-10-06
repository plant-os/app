import 'package:plantos/src/models/company.dart';

class Recipe {
  final String id;
  final String deviceId;
  final String name;
  final String deviceZone;
  final String registryId;
  final Company company;
  final Ph ph;
  final Ec ec;
  Recipe(this.id, this.deviceId, this.deviceZone, this.name, this.registryId,
      this.company, this.ec, this.ph);

  Recipe.fromJson(Map<String, dynamic> json)
      : id = json['Id'],
        company =
            json['Company'] != null ? Company.fromJson(json['Company']) : null,
        deviceId = json['DeviceId'] ?? null,
        deviceZone = json['DeviceZone'] ?? null,
        name = json['Name'],
        registryId = json['RegistryId'] ?? null,
        ec = json['EC'] != null ? Ec.fromJson(json['EC']) : null,
        ph = json['pH'] != null ? Ph.fromJson(json["pH"]) : null;

  Map<String, dynamic> toJson() => {
        'Id': id,
        'Company': company,
        'DeviceId': deviceId,
        'DeviceZone': deviceZone,
        'Name': name,
        'RegistryId': registryId,
        'Ec': ec,
        'pH': ph
      };
}

class Ph {
  final double min;
  final double max;
  final double optimal;
  Ph(this.max, this.min, this.optimal);
  Ph.fromJson(Map<String, dynamic> json)
      : min = (json['Min'] as num).toDouble() ?? null,
        max = (json['Max'] as num).toDouble() ?? null,
        optimal = (json['Optimal'] as num).toDouble() ?? null;
}

class Ec {
  final double min;
  final double max;
  final double optimal;
  Ec(this.max, this.min, this.optimal);
  Ec.fromJson(Map<String, dynamic> json)
      : min = (json['Min'] as num).toDouble() ?? null,
        max = (json['Max'] as num).toDouble() ?? null,
        optimal = (json['Optimal'] as num).toDouble() ?? null;
}
