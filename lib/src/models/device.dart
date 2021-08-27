import 'dart:ui';

import 'company.dart';

class Device {
  /// The firestore Id of this document.
  /// @deprecated
  final String id;

  final bool connected;

  /// The device id in cloud iot core that's used to receive telemetry.
  final String deviceId;

  /// The device id of the MQTT subscriber that controls the pumps and the
  /// valves. This is where trigger messages will be sent to. This can be the
  /// same as DeviceId.
  // final String controlDeviceId;

  final String deviceZone;

  final String description;

  final bool outdoor;

  final bool indoor;

  final String location;

  final Company? company;

  //final DeviceType DeviceType;

  final bool active;

  final bool demo;

  //Attachments?: Attachment[];

  final String registryId;

  // final double lastHeartbeatTimeInSeconds;

  final String? cropId;

  //Recipe?: Recipe;

  // final double latestEC;
  // final double latestPH;
  // final double latestAirTemperature;
  // final double latestWaterTemperature;
  // final double latestHumidity;

  //LatestUpdateTime: firestore.Timestamp;
  Device(
      this.id,
      this.connected,
      this.deviceId,
      this.deviceZone,
      this.description,
      this.outdoor,
      this.indoor,
      this.location,
      this.company,
      this.active,
      this.demo,
      this.registryId,
      this.cropId);

  Device.fromJson(String id, Map<String, dynamic> json)
      : id = id,
        connected = json['Connected'] ?? null,
        deviceId = json['DeviceId'] ?? null,
        deviceZone = json['DeviceZone'] ?? null,
        description = json['Description'] ?? null,
        outdoor = json['Outdoor'] ?? null,
        indoor = json['Indoor'] ?? null,
        location = json['Location'] ?? null,
        company =
            json['Company'] != null ? Company.fromJson(json['Company']) : null,
        active = json['Active'] ?? null,
        demo = json['Demo'] ?? null,
        registryId = json['RegistryId'] ?? null,
        cropId = json['CropId'] ?? null;

  Map<String, dynamic> toJson() => {
        'Id': id,
        'Connected': connected,
        'DeviceId': deviceId,
        'DeviceZone': deviceZone,
        'Description': description,
        'Outdoor': outdoor,
        'Indoor': indoor,
        'Location': location,
        'Company': company != null ? company!.toJson() : null,
        'Active': active,
        'Demo': demo,
        'RegistryId': registryId,
        'CropId': cropId,
      };

  @override
  String toString() {
    return "Device${toJson()}";
  }

  @override
  bool operator ==(dynamic o) =>
      o is Device &&
      o.id == id &&
      o.connected == connected &&
      o.deviceId == deviceId &&
      o.deviceZone == deviceZone &&
      o.description == description &&
      o.outdoor == outdoor &&
      o.indoor == indoor &&
      o.location == location &&
      o.company == company &&
      o.active == active &&
      o.demo == demo &&
      o.registryId == registryId &&
      o.cropId == cropId;

  @override
  int get hashCode => hashValues(
      id,
      connected,
      deviceId,
      deviceZone,
      description,
      outdoor,
      indoor,
      location,
      company,
      active,
      demo,
      registryId,
      cropId);
}
