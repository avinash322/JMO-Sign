import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart'; // Import untuk PDF viewer

class PDFScreen extends StatelessWidget {
  final String pdfBase64;

  const PDFScreen({Key? key, required this.pdfBase64}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pdfBytes = base64Decode(pdfBase64);

    print(pdfBytes);

    return Scaffold(
      appBar: AppBar(title: const Text("PDF Preview")),
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
