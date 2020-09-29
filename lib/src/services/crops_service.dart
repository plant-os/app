import 'package:cloud_firestore/cloud_firestore.dart';

class CropsService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  getCropslist() {
    firestore.collection("crops").get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((f) => print('${f.data}}'));
    });
  }
}
