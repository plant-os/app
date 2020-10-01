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
        company = Company.fromJson(json['Company']),
        deviceId = json['DeviceId'],
        deviceZone = json['DeviceZone'],
        name = json['Name'],
        registryId = json['RegistryId'],
        ec = Ec.fromJson(json['EC']),
        ph = Ph.fromJson(json["pH"]);

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
  final int min;
  final int max;
  final int optimal;
  Ph(this.max, this.min, this.optimal);
  Ph.fromJson(Map<String, dynamic> json)
      : min = json['Min'],
        max = json['Max'],
        optimal = json['Optimal'];
}

class Ec {
  final int min;
  final int max;
  final int optimal;
  Ec(this.max, this.min, this.optimal);
  Ec.fromJson(Map<String, dynamic> json)
      : min = json['Min'],
        max = json['Max'],
        optimal = json['Optimal'];
}
