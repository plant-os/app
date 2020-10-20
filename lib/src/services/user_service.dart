import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plantos/src/models/user.dart';

class UserService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<UserModel> getCurrentUserDetails(String email) async {
    var user = await firestore
        .collection("users")
        .where('Email', isEqualTo: email)
        .get();
    return UserModel.fromJson(user.docs.first.data());
  }
}
