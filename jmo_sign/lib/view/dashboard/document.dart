import 'dart:typed_data';
import 'package:intl/intl.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jmo_sign/service/auth/documentService.dart';
import 'package:sidebarx/sidebarx.dart';

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
              _signatureImage = signatureData; // Simpan tanda tangan
            });
          },
          onCancel: () {
            Navigator.of(context).pop(); // Opsional, bisa untuk cancel action
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
    // Sample data based on the document object (you can adjust it according to your actual data)

    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      isScrollControlled: true, // To make the modal full screen if necessary
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 500,
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
            ],
          ),
        );
      },
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
        // SidebarX di kiri dengan icon yang berada di tengah
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
                    Color(0xFF478778), // Hijau
                    // Putih
                  ],
                  begin: Alignment.topLeft, // Mulai dari pojok kiri atas
                  end: Alignment.bottomRight, // Berakhir di pojok kanan bawah
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
                flex: 4, // Konten utama akan mengambil lebih banyak ruang
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: FutureBuilder<List<dynamic>>(
                      future: _documentService.fetchDocument(
                          context:
                              context), // Ganti dengan method fetch yang sesuai
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
                                  ))); // Menampilkan error jika terjadi
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
                          ); // Menangani jika data kosong
                        }

                        // Filter data berdasarkan target
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

                            // Card pertama atau item yang diambil dari Firestore
                            ...filteredDocuments.map((document) {
                              return GestureDetector(
                                onTap: () {
                                  _showSignatureModal(document);
                                }, // Fungsi untuk menampilkan modal
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
                                              Text(
                                                  document
                                                      .title, // Tampilkan title dokumen
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
                    flex: 4, // Konten utama akan mengambil lebih banyak ruang
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: FutureBuilder<List<dynamic>>(
                          future: _documentService.fetchDocument(
                              context:
                                  context), // Ganti dengan metode fetch data Anda
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                  child:
                                      CircularProgressIndicator()); // Loading saat data sedang diambil
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
                                      ))); // Menampilkan error jika terjadi
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

                            // Filter data berdasarkan target
                            List filteredDocuments = snapshot.data!
                                .where((document) =>
                                    document.target != widget.userData.name)
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
                                // Tampilkan daftar dokumen
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
                                                Text(
                                                    document
                                                        .title, // Tampilkan title dokumen
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
                    flex: 4, // Konten utama akan mengambil lebih banyak ruang
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: FutureBuilder<List<dynamic>>(
                          future: _documentService.fetchDocument(
                              context:
                                  context), // Ganti dengan metode fetch data Anda
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                  child:
                                      CircularProgressIndicator()); // Loading saat data sedang diambil
                            }

                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}',
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      )))); // Menampilkan error jika terjadi
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

                            // Filter data berdasarkan target
                            List filteredDocuments = snapshot.data!
                                .where(
                                    (document) => document.target == "complete")
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

                            return Column(
                              children: [
                                ListView(
                                  padding: EdgeInsets.all(16),
                                  children: [
                                    // Tampilkan daftar dokumen
                                    ...filteredDocuments.map((document) {
                                      return Card(
                                        elevation: 4,
                                        color: Color(0xFF9FE2BF),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                                    Text(
                                                        document
                                                            .title, // Tampilkan title dokumen
                                                        style:
                                                            GoogleFonts.poppins(
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
                                                      style:
                                                          GoogleFonts.poppins(
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
                                                Icons
                                                    .download_for_offline_outlined,
                                                color: Color(0xFF478778),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ),
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
