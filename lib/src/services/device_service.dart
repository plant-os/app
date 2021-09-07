import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plantos/src/models/company.dart';
import 'package:plantos/src/models/device.dart';

class DeviceService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  DeviceStateModel parseDeviceStateFromJson(Map<String, dynamic> json) {
    return DeviceStateModel(
      json['humidity'],
      json['ec'],
      json['smoothed_ec'],
      json['ec_status'],
      json['temperature'],
      json['rtd'],
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
    );
  }

  Device parseDeviceFromJson(String id, Map<String, dynamic> json) {
    return Device(
        id,
        json['DeviceId'],
        json['DeviceZone'],
        json['Description'],
        json['Outdoor'],
        json['Indoor'],
        json['Location'],
        Company.fromJson(json['Company']),
        json['Active'],
        json['Demo'],
        json['RegistryId'],
        json['State'] == null ? null : parseDeviceStateFromJson(json['State']));
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
}
