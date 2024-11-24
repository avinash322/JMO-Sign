import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jmo_sign/view/auth/login.dart';

import '../../component/alertDialog.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;

      await _firestore.collection('User').doc(userId).set({
        'id': userId,
        'email': email,
        'name': name,
        'total_task': 0,
        'need_to_sign': 0,
        'waiting_for_the_others': 0,
      });

      showCustomAlertDialogOneDialog(
        context: context,
        title: 'User registered!',
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (Route<dynamic> route) => false,
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showCustomAlertDialogOneDialog(
          context: context,
          title: 'The account already exists for that email.',
          onPressed: () {
            Navigator.of(context).pop();
          },
        );
      } else if (e.code == 'weak-password') {
        showCustomAlertDialogOneDialog(
          context: context,
          title: 'The password provided is too weak.',
          onPressed: () {
            Navigator.of(context).pop();
          },
        );
      }
    } catch (e) {
      showCustomAlertDialogOneDialog(
        context: context,
        title: 'An error occurred: $e',
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
    }
  }
}
