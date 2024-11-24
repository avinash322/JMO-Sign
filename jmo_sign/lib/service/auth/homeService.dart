import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jmo_sign/model/user.dart';
import 'package:jmo_sign/view/dashboard/home.dart';

import '../../component/alertDialog.dart';
import '../../model/document.dart';
import '../../model/user.dart';
import '../../view/dashboard/dashboard.dart';

class HomeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserData?> refreshTask(
    context,
    userid,
  ) async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('User').doc(userid).get();

      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Document').get();

      int needToSign = 0;
      int waitingForTheOthers = 0;
      int totalTask = 0;

      for (var doc in querySnapshot.docs) {
        final documentData = doc.data() as Map<String, dynamic>;

        final target = documentData['target'] ?? '';
        final author1 = documentData['author_1'] ?? '';
        final author2 = documentData['author_2'] ?? '';
        final author3 = documentData['author_3'] ?? '';

        if (target == userDoc['name']) {
          needToSign++;
        }

        if (target != "complete" &&
            target != userDoc['name'] &&
            (author1 == userDoc['name'] ||
                author2 == userDoc['name'] ||
                author3 == userDoc['name'])) {
          waitingForTheOthers++;
        }

        totalTask = needToSign + waitingForTheOthers;
      }

      UserData userData = UserData(
        id: userDoc['id'] ?? '',
        email: userDoc['email'] ?? '',
        name: userDoc['name'] ?? '',
        needToSign: needToSign,
        totalTask: totalTask,
        waitingForTheOthers: waitingForTheOthers,
      );

      return userData;
    } catch (e) {
      showCustomAlertDialogOneDialog(
        context: context,
        title: "An error occurred: $e",
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
      print("An error occurred: $e");
      return null;
    }
  }

  Future<List<String>> fetchUserNames({required BuildContext context}) async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('User').get();

      List<String> names = querySnapshot.docs.map((doc) {
        return doc['name'] as String;
      }).toList();

      return names;
    } catch (e) {
      showCustomAlertDialogOneDialog(
        context: context,
        title: 'Error fetching user names: $e',
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
      print('Error fetching user names: $e');
      return [];
    }
  }

  Future<Document?> SubmitDocument(
      {required UserData userData,
      required String title,
      required String target,
      required String author1,
      String? author2,
      String? author3,
      required String image,
      required BuildContext context}) async {
    try {
      CollectionReference ref =
          FirebaseFirestore.instance.collection('Document');

      String docId = ref.doc().id;

      await FirebaseFirestore.instance.collection('Document').doc(docId).get();

      Document doc = Document(
        id: docId,
        title: title,
        date: DateTime.now().toString(),
        target: target,
        author1: author1,
        author2: author2,
        author3: author3,
        image: image,
      );

      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('Document')
          .add(doc.toMap());

      doc.id = docRef.id;

      print("Document submitted successfully. Document ID: ${doc.id}");

      showCustomAlertDialogOneDialog(
        context: context,
        title: 'Document Created!',
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => DashboardScreen(
                      userData: userData,
                    )),
            (Route<dynamic> route) => false,
          );
        },
      );

      return doc;
    } on FirebaseAuthMultiFactorException catch (e) {
      print("Error: ${e.message}");
      showCustomAlertDialogOneDialog(
        context: context,
        title: 'Error: ${e.message}.',
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
      return null;
    } catch (e) {
      showCustomAlertDialogOneDialog(
        context: context,
        title: "An error occurred: $e",
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
      print("An error occurred: $e");
      return null;
    }
  }
}
