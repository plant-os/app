import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plantos/src/models/user.dart';

class UserService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Returns the user document for the user with the given email. If no users
  // have this email address null is returned.
  Future<UserModel?> getUserByEmail(String email) async {
    var users = await firestore
        .collection("users")
        .where('Email', isEqualTo: email)
        .get();
    if (users.size == 0) {
      return null;
    }
    return UserModel.fromJson(users.docs.first.data());
  }
}
