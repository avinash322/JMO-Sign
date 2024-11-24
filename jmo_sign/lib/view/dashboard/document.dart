import 'dart:convert';
import 'dart:typed_data';
import 'package:intl/intl.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jmo_sign/service/auth/documentService.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../component/PDF_Viewer.dart';
import '../../component/signingModal.dart';
import '../../model/document.dart';
import '../../model/user.dart';

class DocumentScreen extends StatefulWidget {
  final UserData userData;

  const DocumentScreen({
    super.key,
    required this.userData,
  });

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  late final SidebarXController _sidebarController;
  String tabstatus = "signing";
  Uint8List? _signatureImage;
  final DocumentService _documentService = DocumentService();
  Object documentList = [];

  void _showSignatureModal(documentData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SignatureModal(
          userData: widget.userData,
          documentData: documentData,
          onConfirm: (signatureData) {
            setState(() {
              _signatureImage = signatureData;
            });
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  Future<void> fetchDocumentNames() async {
    Object documentObject =
        await _documentService.fetchDocument(context: context);

    print(documentObject);
    setState(() {
      documentList = documentObject;
    });
  }

  void showCustomModal(BuildContext context, dynamic document) {
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 500,
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Document Timeline",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              const SizedBox(height: 16),
              Container(
                width: 30,
                height: 30,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.amber),
              ),
              Text("Document Signing Created",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
              Container(
                width: 2,
                height: 40,
                color: Colors.amber,
              ),
              document.target == document.author2
                  ? Column(
                      children: [
                        const SizedBox(height: 5),
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Color(0xFFF88379)),
                        ),
                        Text("${document.author1} Done Signing",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Container(
                          width: 2,
                          height: 40,
                          color: Color(0xFFF88379),
                        ),
                        const SizedBox(height: 5),
                        SpinKitRing(
                          color: Color(0xFF87CEEB),
                          size: 30,
                        ),
                        Text("Waiting for ${document.author2} Signing",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                      ],
                    )
                  : document.target == document.author3
                      ? Column(
                          children: [
                            const SizedBox(height: 5),
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFF88379)),
                            ),
                            Text("${document.author1} Done Signing",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )),
                            Container(
                              width: 2,
                              height: 40,
                              color: Color(0xFFF88379),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF87CEEB)),
                            ),
                            Text("${document.author2} Done Signing",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )),
                            Container(
                              width: 2,
                              height: 40,
                              color: Color(0xFF87CEEB),
                            ),
                            const SizedBox(height: 5),
                            SpinKitRing(
                              color: Color(0xFF9FE2BF),
                              size: 30,
                            ),
                            Text("Waiting for ${document.author3} Signing",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )),
                          ],
                        )
                      : Container()
            ],
          ),
        );
      },
    );
  }

  Future<String> convertImageToPdfBase64(String base64Image) async {
    Uint8List imageBytes = base64Decode(base64Image);

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Image(
            pw.MemoryImage(imageBytes),
            width: 500,
            height: 500,
          );
        },
      ),
    );

    final pdfBytes = await pdf.save();
    return base64Encode(pdfBytes);
  }

  void navigateToPDFScreen(BuildContext context, Document document) async {
    final pdfBase64 = await convertImageToPdfBase64(document.image);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFScreen(
          pdfBase64: pdfBase64,
          documentData: document,
          userData: widget.userData,
          viewonly: true,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _sidebarController = SidebarXController(selectedIndex: 0);
    fetchDocumentNames();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Row(
      children: [
        SidebarX(
          theme: SidebarXTheme(
              selectedIconTheme: IconThemeData(
                color: Colors.amber,
              ),
              iconTheme: IconThemeData(
                color: Colors.grey,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF9FE2BF),
                    Color(0xFF478778),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              )),
          showToggleButton: false,
          controller: _sidebarController,
          items: [
            SidebarXItem(
              onTap: () {
                setState(() {
                  tabstatus = "signing";
                });
              },
              icon: CupertinoIcons.signature,
            ),
            SidebarXItem(
              onTap: () {
                setState(() {
                  tabstatus = "waiting";
                });
              },
              icon: CupertinoIcons.doc_person_fill,
            ),
            SidebarXItem(
              onTap: () {
                setState(() {
                  tabstatus = "complete";
                });
              },
              icon: CupertinoIcons.doc_checkmark_fill,
            ),
          ],
        ),
        tabstatus == "signing"
            ? Expanded(
                flex: 4,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: FutureBuilder<List<dynamic>>(
                      future: _documentService.fetchDocument(context: context),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )));
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(
                            child: Text(
                              'No Document Available',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }

                        List filteredDocuments = snapshot.data!
                            .where((document) =>
                                document.target == widget.userData.name)
                            .toList();

                        if (filteredDocuments.isEmpty) {
                          return Center(
                            child: Text(
                              'No Document Available',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }

                        return ListView(
                          padding: EdgeInsets.all(16),
                          children: [
                            Text('Waiting for Your Signing',
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold))),
                            ...filteredDocuments.map((document) {
                              return GestureDetector(
                                onTap: () {
                                  _showSignatureModal(document);
                                },
                                child: Card(
                                  elevation: 4,
                                  color: Color(0xFFF0E68C),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      children: [
                                        SpinKitWaveSpinner(
                                          color: Color(0xFFE49B0F),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(document.title,
                                                  style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  )),
                                              SizedBox(height: 8),
                                              Text(
                                                "Date: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(document.date))}",
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          color: Color(0xFFE49B0F),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              )
            : tabstatus == "waiting"
                ? Expanded(
                    flex: 4,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: FutureBuilder<List<dynamic>>(
                          future:
                              _documentService.fetchDocument(context: context),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }

                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )));
                            }

                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Center(
                                child: Text(
                                  'No Pending Document Available',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }

                            List filteredDocuments = snapshot.data!
                                .where((document) =>
                                    (document.author1 == widget.userData.name ||
                                        document.author2 ==
                                            widget.userData.name ||
                                        document.author3 ==
                                            widget.userData.name) &&
                                    document.target != "complete")
                                .toList();

                            if (filteredDocuments.isEmpty) {
                              return Center(
                                child: Text(
                                  'No Pending Document Available',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }

                            return ListView(
                              padding: EdgeInsets.all(16),
                              children: [
                                Text(
                                  'Waiting For Another Person',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                ...filteredDocuments.map((document) {
                                  return Card(
                                    elevation: 4,
                                    color: Color(0xFF87CEEB),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        children: [
                                          SpinKitWaveSpinner(
                                            color: Color(0xFF4682B4),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(document.title,
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    )),
                                                SizedBox(height: 8),
                                                Text(
                                                  "Date: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(document.date))}",
                                                  style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              showCustomModal(
                                                  context, document);
                                            },
                                            child: Icon(
                                              Icons.search_outlined,
                                              color: Color(0xFF4682B4),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    flex: 4,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: FutureBuilder<List<dynamic>>(
                          future:
                              _documentService.fetchDocument(context: context),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }

                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}',
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ))));
                            }

                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Center(
                                child: Text(
                                  'No Completed Document Available',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }

                            List filteredDocuments = snapshot.data!
                                .where((document) =>
                                    (document.author1 == widget.userData.name ||
                                        document.author2 ==
                                            widget.userData.name ||
                                        document.author3 ==
                                            widget.userData.name) &&
                                    document.target == "complete")
                                .toList();

                            if (filteredDocuments.isEmpty) {
                              return Center(
                                child: Text(
                                  'No Completed Document Available',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }

                            return ListView(
                              padding: EdgeInsets.all(16),
                              children: [
                                Text(
                                  'Complete Signing',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                ...filteredDocuments.map((document) {
                                  return Card(
                                    elevation: 4,
                                    color: Color(0xFF9FE2BF),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        children: [
                                          SpinKitWaveSpinner(
                                            color: Color(0xFF478778),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(document.title,
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    )),
                                                SizedBox(height: 8),
                                                Text(
                                                  "Date: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(document.date))}",
                                                  style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              navigateToPDFScreen(
                                                  context, document);
                                            },
                                            child: Icon(
                                              CupertinoIcons
                                                  .doc_text_viewfinder,
                                              color: Color(0xFF478778),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  )
      ],
    );
  }
}
