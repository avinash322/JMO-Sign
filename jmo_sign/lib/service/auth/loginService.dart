import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:jmo_sign/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../view/dashboard/dashboard.dart';

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

        QuerySnapshot querySnapshot =
            await FirebaseFirestore.instance.collection('Document').get();

        int needToSign = 0;
        int waitingForTheOthers = 0;
        int totalTask = 0;

        // Iterasi setiap dokumen di koleksi
        for (var doc in querySnapshot.docs) {
          final documentData = doc.data() as Map<String, dynamic>;

          final target = documentData['target'] ?? '';
          final author1 = documentData['author_1'] ?? '';
          final author2 = documentData['author_2'] ?? '';
          final author3 = documentData['author_3'] ?? '';

          // Jika user adalah target, tambahkan ke needToSign
          if (target == userDoc['name']) {
            needToSign++;
          }

          // Jika user bukan target, tapi dia adalah salah satu dari author
          if (target != userDoc['name'] &&
              (author1 == userDoc['name'] ||
                  author2 == userDoc['name'] ||
                  author3 == userDoc['name'])) {
            waitingForTheOthers++;
          }

          // Hitung total task (jika user ada di dokumen sebagai author atau target)
          if (target == userDoc['name'] ||
              author1 == userDoc['name'] ||
              author2 == userDoc['name'] ||
              author3 == userDoc['name']) {
            totalTask++;
          }
        }

        UserData userData = UserData(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          name: userDoc['name'] ?? '',
          needToSign: needToSign,
          totalTask: totalTask,
          waitingForTheOthers: waitingForTheOthers,
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

  Future<UserData?> AutoLogin(firebaseUser, context) async {
    try {
      if (firebaseUser != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('User')
            .doc(firebaseUser.uid)
            .get();

        QuerySnapshot querySnapshot =
            await FirebaseFirestore.instance.collection('Document').get();

        int needToSign = 0;
        int waitingForTheOthers = 0;
        int totalTask = 0;

        // Iterasi setiap dokumen di koleksi
        for (var doc in querySnapshot.docs) {
          final documentData = doc.data() as Map<String, dynamic>;

          final target = documentData['target'] ?? '';
          final author1 = documentData['author_1'] ?? '';
          final author2 = documentData['author_2'] ?? '';
          final author3 = documentData['author_3'] ?? '';

          // Jika user adalah target, tambahkan ke needToSign
          if (target == userDoc['name']) {
            needToSign++;
          }

          // Jika user bukan target, tapi dia adalah salah satu dari author
          if (target != userDoc['name'] &&
              (author1 == userDoc['name'] ||
                  author2 == userDoc['name'] ||
                  author3 == userDoc['name'])) {
            waitingForTheOthers++;
          }

          // Hitung total task (jika user ada di dokumen sebagai author atau target)
          if (target == userDoc['name'] ||
              author1 == userDoc['name'] ||
              author2 == userDoc['name'] ||
              author3 == userDoc['name']) {
            totalTask++;
          }
        }

        UserData userData = UserData(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          name: userDoc['name'] ?? '',
          needToSign: needToSign,
          totalTask: totalTask,
          waitingForTheOthers: waitingForTheOthers,
        );

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DashboardScreen(
                    userData: userData,
                  )),
        );
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
