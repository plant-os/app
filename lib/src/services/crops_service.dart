import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plantos/src/models/crop.dart';

class CropsService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<Crop>> getCropslistPast(String companyId) {
    var list = firestore
        .collection("crops")
        .where('Company.Id', isEqualTo: companyId)
        .where('FertigationCrop', isEqualTo: true)
        .where('CropState.Harvested', isEqualTo: true);
    return list.snapshots().map(
          (cropsList) => cropsList.docs.map(
            (crop) => Crop.fromJson(
              crop.data(),
            ),
          ),
        );
  }

  Stream<List<Crop>> getCropslistOngoing(String companyId) {
    var list = firestore
        .collection("crops")
        .where('Company.Id', isEqualTo: companyId)
        .where('FertigationCrop', isEqualTo: true)
        .where('CropState.Harvested', isEqualTo: false);
    return list.snapshots().map(
          (cropsList) => cropsList.docs.map(
            (crop) => Crop.fromJson(
              crop.data(),
            ),
          ),
        );
  }

  // addCrop() {
  //   var crop = Crop(
  //       "name",
  //       "id",
  //       Company("id", "registryId", "address1", "address2", "state", "city",
  //           "country", "postcode", "name"),
  //       [
  //         Camera(
  //             "id",
  //             "description",
  //             "cropId",
  //             Company("id", "registryId", "address1", "address2", "state",
  //                 "city", "country", "postcode", "name"),
  //             null)
  //       ],
  //       null,
  //       true,
  //       "ec",
  //       DateTime(1233),
  //       CropState(true, false, false, false, false),
  //       Schedule(),
  //       true);
  //   firestore.collection("crops").add(crop.toJson());
  // }
}
