import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plantos/src/models/camera.dart';
import 'package:plantos/src/models/company.dart';
import 'package:plantos/src/models/crop.dart';

class CropsService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  getCropslist() {
    firestore.collection("crops").get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((f) => print('${f.data()}}'));
    });
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
