import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pdf_manipulator/pdf_manipulator.dart';
import 'package:signature/signature.dart';
import 'dart:typed_data'; // Import untuk Uint8List
import 'package:pdf/widgets.dart' as pw; // Import untuk membuat PDF
import 'package:printing/printing.dart';

import 'PDF_Viewer.dart'; // Import untuk menampilkan atau mencetak PDF

class SignatureModal extends StatefulWidget {
  final Function(Uint8List?) onConfirm; // Callback untuk OK
  final VoidCallback? onCancel; // Callback untuk Cancel (opsional)

  const SignatureModal({
    Key? key,
    required this.onConfirm,
    this.onCancel,
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

  Future<void> _showPDFPreview(Uint8List? signature) async {
    if (signature == null) return;

    // Buat dokumen PDF
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(
              pw.MemoryImage(signature),
              width: 200,
              height: 100,
            ),
          );
        },
      ),
    );

    // String BASE64 =
    //     "JVBERi0xLjUKJcKlwrHDqwolIGh0dHBzOi8vZ2l0aHViLmNvbS9EYXZCZnIvZGFydF9wZGYKMSAwIG9iago8PC9UeXBlL1BhZ2VzL0tpZHNbMyAwIFJdL0NvdW50IDE+PgplbmRvYmoKMiAwIG9iago8PC9UeXBlL0NhdGFsb2cvVmVyc2lvbi8xLjcvUGFnZXMgMSAwIFIvUGFnZU1vZGUvVXNlTm9uZT4+CmVuZG9iagozIDAgb2JqCjw8L1R5cGUvUGFnZS9SZXNvdXJjZXM8PC9Qcm9jU2V0Wy9QREYvVGV4dC9JbWFnZUIvSW1hZ2VDXS9YT2JqZWN0PDwvSTUgNSAwIFI+Pj4+L1BhcmVudCAxIDAgUi9NZWRpYUJveFswIDAgNTk1LjI3NTU5IDg0MS44ODk3Nl0vQ29udGVudHMgNCAwIFI+PgplbmRvYmoKNCAwIG9iago8PC9GaWx0ZXIvRmxhdGVEZWNvZGUvTGVuZ3RoIDkzPj5zdHJlYW0KeJwzUAgpUihUMFQwAEJDBVMzPTNLI0skRnIuSNrCXM/EyNLITMHY0ETPyNTQ0lzB0MBcz8DY0MgUyDJQKEpVCFfIAymFC4NNBEph0ww0Vd/TVMElXyEQDAFo+hwNCmVuZHN0cmVhbQplbmRvYmoKNSAwIG9iago8PC9UeXBlL1hPYmplY3QvU3VidHlwZS9JbWFnZS9XaWR0aCAxMzcvSGVpZ2h0IDEyOC9CaXRzUGVyQ29tcG9uZW50IDgvTmFtZS9JNS9Db2xvclNwYWNlL0RldmljZVJHQi9TTWFzayA2IDAgUi9GaWx0ZXIvRmxhdGVEZWNvZGUvTGVuZ3RoIDI5OTk+PnN0cmVhbQp4nO2dWUwTaxvHD0IUUFDZUVCB0hZwK6UKyFKoIMjmhoCAeiEaNZq4Y0BRY9CAaDAuQKIXakTQC28AVzBcSIwRFUVRokYv3MC4xShR8fvL+9nD4XCglJl5O8vvYvJ2+i7/mafzPM87";

    // Uint8List pdfBytes = base64Decode(BASE64);

    // final existingPdf = pw.MemoryImage(pdfBytes);

    // pdf.addPage(pw.Page(build: (pw.Context context) {
    //   return pw.Image(existingPdf);
    // }));

    generateAndNavigate(context, pdf);
  }

  Future<void> generateAndNavigate(
      BuildContext context, pw.Document pdf) async {
    // Proses pembuatan PDF
    final pdfBytes = await pdf.save(); // Menunggu hasil pdf.save()

    String BASE64 =
        "JVBERi0xLjUKJcKlwrHDqwolIGh0dHBzOi8vZ2l0aHViLmNvbS9EYXZCZnIvZGFydF9wZGYKMSAwIG9iago8PC9UeXBlL1BhZ2VzL0tpZHNbMyAwIFJdL0NvdW50IDE+PgplbmRvYmoKMiAwIG9iago8PC9UeXBlL0NhdGFsb2cvVmVyc2lvbi8xLjcvUGFnZXMgMSAwIFIvUGFnZU1vZGUvVXNlTm9uZT4+CmVuZG9iagozIDAgb2JqCjw8L1R5cGUvUGFnZS9SZXNvdXJjZXM8PC9Qcm9jU2V0Wy9QREYvVGV4dC9JbWFnZUIvSW1hZ2VDXS9YT2JqZWN0PDwvSTUgNSAwIFI+Pj4+L1BhcmVudCAxIDAgUi9NZWRpYUJveFswIDAgNTk1LjI3NTU5IDg0MS44ODk3Nl0vQ29udGVudHMgNCAwIFI+PgplbmRvYmoKNCAwIG9iago8PC9GaWx0ZXIvRmxhdGVEZWNvZGUvTGVuZ3RoIDkzPj5zdHJlYW0KeJwzUAgpUihUMFQwAEJDBVMzPTNLI0skRnIuSNrCXM/EyNLITMHY0ETPyNTQ0lzB0MBcz8DY0MgUyDJQKEpVCFfIAymFC4NNBEph0ww0Vd/TVMElXyEQDAFo+hwNCmVuZHN0cmVhbQplbmRvYmoKNSAwIG9iago8PC9UeXBlL1hPYmplY3QvU3VidHlwZS9JbWFnZS9XaWR0aCAxMzcvSGVpZ2h0IDEyOC9CaXRzUGVyQ29tcG9uZW50IDgvTmFtZS9JNS9Db2xvclNwYWNlL0RldmljZVJHQi9TTWFzayA2IDAgUi9GaWx0ZXIvRmxhdGVEZWNvZGUvTGVuZ3RoIDI5OTk+PnN0cmVhbQp4nO2dWUwTaxvHD0IUUFDZUVCB0hZwK6UKyFKoIMjmhoCAeiEaNZq4Y0BRY9CAaDAuQKIXakTQC28AVzBcSIwRFUVRokYv3MC4xShR8fvL+9nD4XCglJl5O8vvYvJ2+i7/mafzPM87";
    Uint8List pdfBytes1 = base64Decode(BASE64);

    String? mergedPdfPath = await PdfManipulator().mergePDFs(
      params: PDFMergerParams(
          pdfsPaths: [pdfBytes1.toString(), pdfBytes.toString()]),
    );

    final pdfBase64 = base64Encode(pdfBytes);

    print("pdfBase64: $pdfBase64"); // Mencetak pdfBytes (Uint8List)

    // String BASE64 =
    //     "JVBERi0xLjUKJcKlwrHDqwolIGh0dHBzOi8vZ2l0aHViLmNvbS9EYXZCZnIvZGFydF9wZGYKMSAwIG9iago8PC9UeXBlL1BhZ2VzL0tpZHNbMyAwIFJdL0NvdW50IDE+PgplbmRvYmoKMiAwIG9iago8PC9UeXBlL0NhdGFsb2cvVmVyc2lvbi8xLjcvUGFnZXMgMSAwIFIvUGFnZU1vZGUvVXNlTm9uZT4+CmVuZG9iagozIDAgb2JqCjw8L1R5cGUvUGFnZS9SZXNvdXJjZXM8PC9Qcm9jU2V0Wy9QREYvVGV4dC9JbWFnZUIvSW1hZ2VDXS9YT2JqZWN0PDwvSTUgNSAwIFI+Pj4+L1BhcmVudCAxIDAgUi9NZWRpYUJveFswIDAgNTk1LjI3NTU5IDg0MS44ODk3Nl0vQ29udGVudHMgNCAwIFI+PgplbmRvYmoKNCAwIG9iago8PC9GaWx0ZXIvRmxhdGVEZWNvZGUvTGVuZ3RoIDkzPj5zdHJlYW0KeJwzUAgpUihUMFQwAEJDBVMzPTNLI0skRnIuSNrCXM/EyNLITMHY0ETPyNTQ0lzB0MBcz8DY0MgUyDJQKEpVCFfIAymFC4NNBEph0ww0Vd/TVMElXyEQDAFo+hwNCmVuZHN0cmVhbQplbmRvYmoKNSAwIG9iago8PC9UeXBlL1hPYmplY3QvU3VidHlwZS9JbWFnZS9XaWR0aCAxMzcvSGVpZ2h0IDEyOC9CaXRzUGVyQ29tcG9uZW50IDgvTmFtZS9JNS9Db2xvclNwYWNlL0RldmljZVJHQi9TTWFzayA2IDAgUi9GaWx0ZXIvRmxhdGVEZWNvZGUvTGVuZ3RoIDI5OTk+PnN0cmVhbQp4nO2dWUwTaxvHD0IUUFDZUVCB0hZwK6UKyFKoIMjmhoCAeiEaNZq4Y0BRY9CAaDAuQKIXakTQC28AVzBcSIwRFUVRokYv3MC4xShR8fvL+9nD4XCglJl5O8vvYvJ2+i7/mafzPM87";

    // String? mergedPdfPath = await PdfManipulator().mergePDFs(
    //   params: PDFMergerParams(pdfsPaths: [BASE64, pdfBase64]),
    // );

    if (pdfBase64 == null) {
      // Menangani jika pdfBytes null
      print("Error: pdfBytes is null");
      return;
    }

    // Memastikan context masih valid sebelum melakukan navigasi
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PDFScreen(pdfBase64: mergedPdfPath.toString())),
      );
    } else {
      print("Context is not valid, cannot navigate.");
    }
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
                    await _showPDFPreview(signatureData);
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
