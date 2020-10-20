import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plantos/src/models/crop.dart';
import 'package:plantos/src/models/user.dart';
import 'package:plantos/src/services/user_service.dart';

class CropsService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final UserService userService = UserService();

  Stream<List<Crop>> getCropslist(String companyId) {
    var list = firestore
        .collection("crops")
        .where('Company.Id', isEqualTo: companyId)
        .where('FertigationCrop', isEqualTo: true);
    return list.snapshots().map((cropsList) => cropsList.docs
        .map(
          (crop) => Crop.fromJson(
            crop.data(),
          ),
        )
        .toList());
  }

  // Stream<List<Crop>> getCropslistOngoing(String companyId) {
  //   var list = firestore
  //       .collection("crops")
  //       .where('Company.Id', isEqualTo: companyId)
  //       .where('FertigationCrop', isEqualTo: true)
  //       .where('CropState.Harvested', isEqualTo: false);
  //   return list.snapshots().map(
  //         (cropsList) => cropsList.docs.map(
  //           (crop) => Crop.fromJson(
  //             crop.data(),
  //           ),
  //         ),
  //       );
  // }

  addCrop(Crop crop, UserModel user) async {
    crop.company = user.company;
    var newCrop = await firestore.collection("crops").add(crop.toJson());
    crop.id = newCrop.id;
    editCrop(crop);
  }

  editCrop(Crop crop) {
    firestore.collection("crops").doc(crop.id).update(crop.toJson());
  }
}
