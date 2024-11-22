import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:jmo_sign/model/user.dart';

class AuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;

  Future<UserData?> loginWithEmailPassword(
      String email, String password) async {
    try {
      final firebase_auth.UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      firebase_auth.User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        UserData userData = UserData(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          name: firebaseUser.displayName ?? "",
          attendanceIn: firebaseUser.displayName ?? "",
          attendanceOut: firebaseUser.displayName ?? "",
        );
        return userData;
      } else {
        return null;
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      }
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
