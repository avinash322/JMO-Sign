import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:developer' as developer;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:pdf_manipulator/pdf_manipulator.dart';
import 'package:signature/signature.dart';
import 'dart:typed_data'; // Import untuk Uint8List
import 'package:pdf/widgets.dart' as pw; // Import untuk membuat PDF
import 'package:printing/printing.dart';

import '../model/document.dart';
import '../model/user.dart';
import 'PDF_Viewer.dart'; // Import untuk menampilkan atau mencetak PDF

class SignatureModal extends StatefulWidget {
  final Function(Uint8List?) onConfirm; // Callback untuk OK
  final VoidCallback? onCancel; // Callback untuk Cancel (opsional)
  final UserData userData;
  final Document documentData;

  const SignatureModal({
    Key? key,
    required this.onConfirm,
    this.onCancel,
    required this.userData,
    required this.documentData,
  }) : super(key: key);

  @override
  _SignatureModalState createState() => _SignatureModalState();
}

class _SignatureModalState extends State<SignatureModal> {
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );
  late String combinedBase64;

  Future<void> _showPDFPreview(Uint8List signature) async {
    // Buat dokumen PDF
    final pdf = pw.Document();

    // Menambahkan gambar ke dalam PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Image(
            pw.MemoryImage(signature),
            width: 500,
            height: 500,
          );
        },
      ),
    );

    // Panggil generateAndNavigate untuk navigasi setelah PDF selesai dibuat
    generateAndNavigate(context, pdf, signature);
  }

  Future<void> generateAndNavigate(
      BuildContext context, pw.Document pdf, Uint8List signature) async {
    final pdfBytes = await pdf.save();
    final pdfBase64 = base64Encode(pdfBytes); // Base64 dari PDF
    var signatureimg = signature;

    // Kondisi jika ada lebih dari satu gambar (signatures)
    String finalPdfBase64 = pdfBase64; // Default jika hanya satu gambar

    // Misalnya, jika ada lebih dari satu gambar
    if (widget.documentData.target == widget.documentData.author2 ||
        widget.documentData.target == widget.documentData.author3) {
      // Gabungkan gambar menjadi satu PDF baru
      String combinedBase64 = await combineImagesToBase64(
        widget.documentData.image,
        base64Encode(signature), // Gantilah dengan base64 gambar yang sesuai
      );
      signatureimg = base64Decode(combinedBase64);

      // Gabungkan gambar-gambar tersebut dalam PDF baru

      final pdf = pw.Document();

      // Menambahkan gambar ke dalam PDF
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Image(
              pw.MemoryImage(base64Decode(combinedBase64)),
              width: 500,
              height: 500,
            );
          },
        ),
      );
      final pdfBytes = await pdf.save();
      final pdfBase64 = base64Encode(pdfBytes);
      finalPdfBase64 = pdfBase64;
    }

    // Navigasi ke PDFScreen dengan base64 dari PDF yang sudah diproses
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFScreen(
            imageBase64: base64Encode(signatureimg),
            pdfBase64: finalPdfBase64,
            documentData: widget.documentData,
            userData: widget.userData,
            viewonly: false,
          ),
        ),
      );
    } else {
      print("Context is not valid, cannot navigate.");
    }
  }

  Future<String> combineImagesToBase64(
      String base64Image1, String base64Image2) async {
    Uint8List bytes1 = base64Decode(base64Image1);
    Uint8List bytes2 = base64Decode(base64Image2);

    // Decode gambar dari byte array
    ui.Image image1 = await decodeImageFromList(bytes1);
    ui.Image image2 = await decodeImageFromList(bytes2);

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    double width = image1.width.toDouble();
    double height = image1.height.toDouble() + image2.height.toDouble();

    // Gambar pertama
    canvas.drawImage(image1, Offset(0, 0), Paint());

    // Gambar kedua ditempatkan setelah gambar pertama
    canvas.drawImage(image2, Offset(0, image1.height.toDouble()), Paint());

    final picture = recorder.endRecording();
    final combinedImage = await picture.toImage(width.toInt(), height.toInt());

    // Convert combined image to base64
    final base64Image = await imageToBase64(combinedImage);
    return base64Image;
  }

  Future<String> imageToBase64(ui.Image image) async {
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return base64Encode(byteData!.buffer.asUint8List());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Tanda Tangan"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 250,
            height: 250,
            color: Colors.grey[200],
            child: Signature(
              controller: _signatureController,
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  _signatureController.clear(); // Reset tanda tangan
                },
                child: const Text("Reset"),
                style: ElevatedButton.styleFrom(primary: Colors.red),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_signatureController.isNotEmpty) {
                    final signatureData =
                        await _signatureController.toPngBytes();
                    widget.onConfirm(signatureData);

                    // Tampilkan preview PDF
                    await _showPDFPreview(signatureData!);
                  } else {
                    widget.onConfirm(null);
                  }
                },
                child: const Text("OK"),
                style: ElevatedButton.styleFrom(primary: Colors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }
}
