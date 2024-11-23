import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:jmo_sign/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('User')
            .doc(firebaseUser.uid)
            .get();

        UserData userData = UserData(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          name: userDoc['name'] ?? '',
          attendanceIn: userDoc['attendance_in'] ?? '',
          attendanceOut: userDoc['attendance_out'] ?? '',
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
