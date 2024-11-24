import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import '../model/document.dart';
import '../model/user.dart';
import '../service/auth/documentService.dart'; // Import untuk PDF viewer

class PDFScreen extends StatefulWidget {
  final String pdfBase64;
  final UserData userData;
  final Document documentData;
  final bool viewonly;
  final String? imageBase64;

  const PDFScreen(
      {Key? key,
      required this.pdfBase64,
      required this.userData,
      required this.documentData,
      required this.viewonly,
      this.imageBase64})
      : super(key: key);

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  final DocumentService _documentService = DocumentService();
  late Uint8List pdfBytes;

  @override
  void initState() {
    super.initState();
    // Mendekode base64 PDF menjadi bytes
    pdfBytes = base64Decode(widget.pdfBase64);
  }

  Future<void> fetchDocumentNames() async {
    String author1 = widget.documentData.author1;
    String? author2 = widget.documentData.author2;
    String? author3 = widget.documentData.author3;
    String target = widget.documentData.target;

    // Menentukan status tanda tangan berdasarkan target
    bool isAuthor1Signed = target == author1 ? true : false;
    bool isAuthor2Signed = author2 != null && target == author2 ? true : false;
    bool isAuthor3Signed = author3 != null && target == author3 ? true : false;

    // if (isAuthor1Signed &&
    //     (author2 == null || isAuthor2Signed) &&
    //     (author3 == null || isAuthor3Signed)) {
    //   target = 'complete';
    // } else
    if (isAuthor1Signed && author2 != "") {
      target = author2!;
    } else if (isAuthor2Signed && author3 != "") {
      target = author3!;
    } else {
      target = 'complete';
    }

    await _documentService.updateDocument(
        author1: author1,
        author2: author2 ?? "",
        author3: author3 ?? "",
        context: context,
        documentId: widget.documentData.id,
        image: widget.imageBase64 ?? "",
        target: target,
        userData: widget.userData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF Preview"),
        actions: [
          if (!widget.viewonly) // Menampilkan IconButton jika viewonly false
            IconButton(
              icon:
                  Icon(CupertinoIcons.arrow_up_right_circle_fill), // Ikon pesan
              onPressed:
                  fetchDocumentNames, // Fungsi untuk menampilkan title dokumen
            ),
        ],
      ),
      body: Center(
        child: PDFView(
          pdfData: pdfBytes,
          onPageError: (page, error) {
            print('Error: $error');
          },
        ),
      ),
    );
  }
}
