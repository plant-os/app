import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plantos/src/models/program.dart';

class ProgramsService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<Program>> list(String companyId) {
    return firestore
        .collection("programs")
        .where('CompanyId', isEqualTo: companyId)
        .snapshots()
        .map((event) => event.docs
            .map((doc) => Program.fromJson(doc.id, doc.data()))
            .toList());
  }

  Future<void> delete(String programId) {
    return firestore.collection("programs").doc(programId).delete();
  }

  Future<Program> add(String name) async {
    var ref =
        await firestore.collection("programs").add(Program("", name).toJson());

    return Program(ref.id, name);
  }
}
