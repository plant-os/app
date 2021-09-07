import 'dart:ui';

import 'company.dart';

class DeviceStateModel {
  final double humidity;
  final double ec;
  final double smoothed_ec;
  final int ec_status;
  final double temperature;
  final double rtd;
  final String version;
  final bool i0;
  final bool i1;
  final bool i2;
  final bool i3;
  final bool i4;
  final bool i5;
  final bool i6;
  final bool i7;
  final bool o0;
  final bool o1;
  final bool o2;
  final bool o3;
  final bool o4;
  final bool o5;
  final bool o6;
  final bool o7;

  DeviceStateModel(
    this.humidity,
    this.ec,
    this.smoothed_ec,
    this.ec_status,
    this.temperature,
    this.rtd,
    this.version,
    this.i0,
    this.i1,
    this.i2,
    this.i3,
    this.i4,
    this.i5,
    this.i6,
    this.i7,
    this.o0,
    this.o1,
    this.o2,
    this.o3,
    this.o4,
    this.o5,
    this.o6,
    this.o7,
  );
}

class Device {
  /// The firestore Id of this document.
  /// @deprecated
  final String id;

  /// The device id in cloud iot core that's used to receive telemetry.
  final String deviceId;

  final String deviceZone;

  final String description;

  final bool outdoor;

  final bool indoor;

  final String location;

  final Company? company;

  final bool active;

  final bool demo;

  final String registryId;

  // TODO: add to firestore.
  final DeviceStateModel? state;

  Device(
    this.id,
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
    this.state,
  );

  Map<String, dynamic> toJson() => {
        'Id': id,
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
      };

  @override
  String toString() {
    return "Device${toJson()}";
  }

  @override
  bool operator ==(dynamic o) =>
      o is Device &&
      o.id == id &&
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
      o.state == state;

  @override
  int get hashCode => hashValues(
        id,
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
        state,
      );
}
