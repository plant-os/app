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

  addCrop(Crop crop, UserModel user) async {
    var newCrop = firestore.collection("crops").doc();
    newCrop
        .set(crop.withValues(company: user.company, id: newCrop.id).toJson());
  }

  Future<void> editCrop(Crop crop) {
    print("updating ${crop.id} => ${crop.toString()}");
    return firestore.collection("crops").doc(crop.id).update(crop.toJson());
  }

  addActionToSkipped(ActionRepeat action) async {
    var newAction = await firestore.collection("skipped").add(action.toJson());
    action.id = newAction.id;
    editActionToSkipped(action);
  }

  editActionToSkipped(ActionRepeat action) {
    firestore.collection("skipped").doc(action.id).update(action.toJson());
  }

  deleteActionFromSkipped(String id) async {
    await firestore.collection("skipped").doc(id).delete();
  }

  Future<List<ActionRepeat>> skippedActions(String cropId) async {
    var foundActionQuerySnapshots = await firestore
        .collection("skipped")
        .where('CropId', isEqualTo: cropId)
        .get();
    List<ActionRepeat> foundActions = foundActionQuerySnapshots.docs
        .map((doc) => ActionRepeat.fromJson(doc.data()))
        .toList();
    return foundActions;
  }
}
