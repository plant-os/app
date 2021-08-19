import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plantos/src/models/crop.dart';
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

  Stream<List<Schedule>> listSchedules(String programId) {
    return firestore
        .collection("programs")
        .doc(programId)
        .collection("schedules")
        .snapshots()
        .map((event) => event.docs
            .map((doc) => Schedule.fromJson(doc.id, doc.data()))
            .toList());
  }

  Future<void> addSchedule(String programId, Schedule s) {
    print("adding schedule to /programs/$programId: $s");
    return firestore
        .collection("programs")
        .doc(programId)
        .collection("schedules")
        .add(s.toJson());
  }

  Future<void> updateSchedule(String programId, String scheduleId, Schedule s) {
    print("updating schedule /programs/$programId/schedules/$scheduleId: $s");
    return firestore
        .collection("programs")
        .doc(programId)
        .collection("schedules")
        .doc(scheduleId)
        .set(s.toJson());
  }

  Future<void> deleteSchedule(String programId, String scheduleId) {
    return firestore
        .collection("programs")
        .doc(programId)
        .collection("schedules")
        .doc(scheduleId)
        .delete();
  }

  Future<void> delete(String programId) {
    return firestore.collection("programs").doc(programId).delete();
  }

  Future<Program> add(String companyId, String name) async {
    var ref = await firestore
        .collection("programs")
        .add(Program("", name, companyId).toJson());

    return Program(ref.id, name, companyId);
  }
}
