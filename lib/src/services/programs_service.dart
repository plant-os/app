import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plantos/src/models/schedule.dart';
import 'package:plantos/src/models/device.dart';
import 'package:plantos/src/models/grow.dart';
import 'package:plantos/src/models/program.dart';

class ProgramsService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  LocalDate parseLocalDateFromJson(Map<String, dynamic> json) {
    return LocalDate(
      year: json['Year'],
      month: json['Month'],
      day: json['Day'],
    );
  }

  Map<String, dynamic> serialiseLocalDateToJson(LocalDate localDate) {
    return {
      'Year': localDate.year,
      'Month': localDate.month,
      'Day': localDate.day,
    };
  }

  Grow parseGrowFromJson(String id, Map<String, dynamic> json) {
    return Grow(
      id: id,
      name: json['Name'],
      programId: json['ProgramId'],
      deviceId: json['DeviceId'],
      plot: json['Plot'],
      state: json['State'],
      startDate: parseLocalDateFromJson(json['StartDate']),
      companyId: json['CompanyId'],
    );
  }

  Map<String, dynamic> serialiseGrowToJson(Grow grow) {
    return {
      'Name': grow.name,
      'ProgramId': grow.programId,
      'DeviceId': grow.deviceId,
      'Plot': grow.plot,
      'State': grow.state,
      'StartDate': serialiseLocalDateToJson(grow.startDate!),
      'CompanyId': grow.companyId,
    };
  }

  Stream<List<Grow>> listGrows(String companyId) {
    return firestore
        .collection("grows")
        .where('CompanyId', isEqualTo: companyId)
        .where('State', isNotEqualTo: "inactive")
        .snapshots()
        .map((event) => event.docs
            .map((doc) => parseGrowFromJson(doc.id, doc.data()))
            .toList());
  }

  Future<DocumentReference> addGrow(Grow grow) {
    return firestore.collection("grows").add(serialiseGrowToJson(grow));
  }

  Future<void> updateGrow(String id, Grow grow) {
    return firestore
        .collection("grows")
        .doc(id)
        .update(serialiseGrowToJson(grow));
  }

  Future<void> deleteGrow(String id) {
    return firestore.collection("grows").doc(id).update({'State': 'inactive'});
  }

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
        .set(s.toJson(), SetOptions(merge: true));
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
        .add(Program(id: "", name: name, companyId: companyId).toJson());

    return Program(id: ref.id, name: name, companyId: companyId);
  }
}
