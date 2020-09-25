import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> login(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> logout() {
    return _firebaseAuth.signOut();
  }

  Future<bool> isLoggedIn() async {
    FirebaseUser currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<String> getCurrentUserId() async {
    return (await _firebaseAuth.currentUser()).uid;
  }
}
