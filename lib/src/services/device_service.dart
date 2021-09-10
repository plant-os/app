import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plantos/src/models/company.dart';
import 'package:plantos/src/models/device.dart';

class DeviceService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  DeviceStateModel parseDeviceStateFromJson(Map<String, dynamic> json) {
    return DeviceStateModel(
      json['humidity'].toDouble(),
      json['ec'].toDouble(),
      json['smoothed_ec'].toDouble(),
      json['ec_status'],
      json['temperature'].toDouble(),
      json['rtd'].toDouble(),
      json['version'],
      json['i0'],
      json['i1'],
      json['i2'],
      json['i3'],
      json['i4'],
      json['i5'],
      json['i6'],
      json['i7'],
      json['o0'],
      json['o1'],
      json['o2'],
      json['o3'],
      json['o4'],
      json['o5'],
      json['o6'],
      json['o7'],
      json['state'].toInt(),
    );
  }

  Device parseDeviceFromJson(String id, Map<String, dynamic> json) {
    print(json);
    return Device(
        id,
        json['DeviceId'],
        json['DeviceZone'],
        json['Description'] ?? "",
        json['Location'],
        Company.fromJson(json['Company']),
        json['RegistryId'],
        json['State'] == null ? null : parseDeviceStateFromJson(json['State']),
        json['LatestUpdateTime']);
  }

  Stream<List<Device>> list(String companyId) {
    return firestore
        .collection("devices")
        .where('Company.Id', isEqualTo: companyId)
        .snapshots()
        .map((devices) => devices.docs
            .map((device) => parseDeviceFromJson(device.id, device.data()))
            .toList());
  }

  Stream<Device> get(String deviceId) {
    return firestore.collection("devices").doc(deviceId).snapshots().map(
        (device) => parseDeviceFromJson(device.id, device.data() ?? Map()));
  }
}
