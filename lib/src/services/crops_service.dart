import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plantos/src/models/camera.dart';
import 'package:plantos/src/models/company.dart';
import 'package:plantos/src/models/crop.dart';

class CropsService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Crop>> getCropslist() async {
    List<Crop> crops = [];
    var list = await firestore.collection("crops").get();
    list.docs.forEach((crop) {
      crops.add(Crop.fromJson(crop.data()));
    });
    return crops;
  }

  addCrop() {
    var crop = Crop(
        "name",
        "id",
        Company("id", "registryId", "address1", "address2", "state", "city",
            "country", "postcode", "name"),
        [
          Camera(
              "id",
              "description",
              "cropId",
              Company("id", "registryId", "address1", "address2", "state",
                  "city", "country", "postcode", "name"),
              null)
        ],
        null,
        true,
        "ec",
        DateTime(1233),
        State(true, false, false, false, false),
        Schedule(),
        true);
    firestore.collection("crops").add(crop.toJson());
  }
}
