import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jmo_sign/model/user.dart';
import 'package:jmo_sign/view/dashboard/home.dart';

import '../../component/alertDialog.dart';
import '../../model/document.dart';
import '../../view/dashboard/dashboard.dart';

class DocumentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fungsi untuk mengambil semua nama dari koleksi User
  Future<List<dynamic>> fetchDocument({required BuildContext context}) async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Document').get();

      // Konversi hasil query menjadi list of Document
      List<Document> documentList = querySnapshot.docs.map((doc) {
        return Document(
          id: doc.id,
          title: doc["title"] ?? "",
          date: doc["date"] ?? "",
          target: doc["target"] ?? "",
          author1: doc["author_1"] ?? "",
          author2: doc["author_2"] ?? "",
          author3: doc["author_3"] ?? "",
          image: doc["image"] ?? "",
        );
      }).toList();

      return documentList;
    } catch (e) {
      showCustomAlertDialogOneDialog(
        context: context,
        title: 'Error fetching document : $e',
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
      print('Error fetching document : $e');
      return []; // Mengembalikan array kosong jika terjadi error
    }
  }

  Future<void> updateDocument({
    required UserData userData,
    required BuildContext context,
    required String documentId, // ID dari dokumen yang ingin diperbarui
    required String target,
    required String author1,
    required String author2,
    required String author3,
    required String image,
  }) async {
    try {
      // Dapatkan referensi dokumen yang ingin diperbarui
      DocumentReference documentRef =
          FirebaseFirestore.instance.collection('Document').doc(documentId);

      // Update data pada dokumen
      await documentRef.update({
        'target': target,
        'author_1': author1,
        'author_2': author2,
        'author_3': author3,
        'image': image,
      });

      // Menampilkan dialog bahwa update berhasil
      showCustomAlertDialogOneDialog(
        context: context,
        title: 'Document Updated Successfully',
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
      print('Document updated successfully');
    } catch (e) {
      // Menampilkan error jika terjadi kesalahan saat update
      showCustomAlertDialogOneDialog(
        context: context,
        title: 'Error updating document: $e',
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
      print('Error updating document: $e');
    }
  }
}