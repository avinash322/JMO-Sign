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
      print(userid);
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('User').doc(userid).get();

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
        if (target != "complete" &&
            target != userDoc['name'] &&
            (author1 == userDoc['name'] ||
                author2 == userDoc['name'] ||
                author3 == userDoc['name'])) {
          waitingForTheOthers++;
        }

        // Hitung total task (jika user ada di dokumen sebagai author atau target)
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

  // Fungsi untuk mengambil semua nama dari koleksi User
  Future<List<String>> fetchUserNames({required BuildContext context}) async {
    try {
      // Ambil data dari koleksi 'User'
      QuerySnapshot querySnapshot = await _firestore.collection('User').get();

      // Ambil semua nama dari field 'name' di setiap dokumen
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
      return []; // Mengembalikan array kosong jika terjadi error
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
      // Ambil data pengguna saat ini
      CollectionReference ref =
          FirebaseFirestore.instance.collection('Document');

      String docId = ref.doc().id;

      // Ambil data pengguna dari koleksi 'User'
      await FirebaseFirestore.instance.collection('Document').doc(docId).get();

      // Membuat Document baru dengan id otomatis dari Firestore
      Document doc = Document(
        id: docId, // Kosongkan id karena Firestore akan menghasilkan id otomatis
        title: title,
        date: DateTime.now().toString(),
        target: target,
        author1: author1,
        author2: author2,
        author3: author3,
        image: image,
      );

      // Simpan dokumen baru ke koleksi 'Documents'
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('Document')
          .add(doc.toMap());

      // Setelah dokumen disimpan, dapatkan id yang dihasilkan
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
