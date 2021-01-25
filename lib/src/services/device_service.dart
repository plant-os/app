import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plantos/src/models/device.dart';

class DeviceService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<Device>> list(String companyId) {
    var list = firestore
        .collection("devices")
        .where('Company.Id', isEqualTo: companyId);
    return list.snapshots().map((devices) => devices.docs
        .map(
          (device) => Device.fromJson(
            device.data(),
          ),
        )
        .toList());
  }
}
