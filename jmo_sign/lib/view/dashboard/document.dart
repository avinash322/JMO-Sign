import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sidebarx/sidebarx.dart';

import '../../component/signingModal.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key});

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  late final SidebarXController _sidebarController;
  String tabstatus = "signing";
  Uint8List? _signatureImage;

  void _showSignatureModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SignatureModal(
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

  @override
  void initState() {
    super.initState();
    _sidebarController = SidebarXController(selectedIndex: 0);
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
                    child: ListView(
                      padding: EdgeInsets.all(16),
                      children: [
                        Text('Waiting for Your Signing',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold))),
                        // Card pertama
                        GestureDetector(
                          onTap: _showSignatureModal,
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
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Document 1",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text("Date: signing"),
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
                        ),
                      ],
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
                        child: ListView(
                          padding: EdgeInsets.all(16),
                          children: [
                            Text('Waiting For Another Person',
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold))),
                            // Card pertama
                            Card(
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
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Document 1",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text("Date: waiting"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    flex: 4, // Konten utama akan mengambil lebih banyak ruang
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: ListView(
                          padding: EdgeInsets.all(16),
                          children: [
                            Text('Signing Complete',
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold))),
                            // Card pertama
                            Card(
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
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Document 1",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text("Date: completed"),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.download_for_offline_outlined,
                                      color: Color(0xFF478778),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
      ],
    );
  }
}
