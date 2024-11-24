import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jmo_sign/model/user.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../component/button.dart';
import '../../component/circularProgressDashboard.dart';
import '../../component/glassmorphismContainer.dart';
import '../../component/textfield.dart';
import '../../model/document.dart';
import '../../service/auth/homeService.dart';

class Homecreen extends StatefulWidget {
  final UserData userData;

  const Homecreen({Key? key, required this.userData}) : super(key: key);

  @override
  State<Homecreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Homecreen> {
  final TextEditingController titleController = TextEditingController();

  String? jumlahauthor;

  String? selectedauthor1;
  String? selectedauthor2;
  String? selectedauthor3;

  bool isChecked = false;
  bool isSubmitDocument = false;
  bool isloading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final HomeService _homeService = HomeService();
  List<String> userNamesList = [];

  @override
  void initState() {
    super.initState();
    fetchUserNames();
  }

  Future<void> fetchUserNames() async {
    List<String> names = await _homeService.fetchUserNames(context: context);
    setState(() {
      userNamesList = names;
    });
  }

  void submitDocumentData() async {
    FocusScope.of(context).unfocus();

    setState(() {
      isloading = true;
    });
    _homeService.SubmitDocument(
        userData: widget.userData,
        title: titleController.text,
        target: widget.userData.name,
        author1: widget.userData.name,
        author2: selectedauthor1 ?? "",
        author3: selectedauthor2 ?? "",
        context: context);

    setState(() {
      isloading = false;
    });
  }

  void showCustomModal() {
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      isScrollControlled:
          true, // Agar modal bisa menggunakan seluruh layar jika perlu
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height *
                  0.8, // Sesuaikan dengan ukuran layar
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Make a New Document Signing',
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.w500)),
                        textAlign: TextAlign.center,
                      ),
                      CustomTextField(
                        controller: titleController,
                        labelText: 'Judul Dokumen',
                        hintText: 'Judul Dokumen',
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: 10),
                      // Checkbox untuk memilih apakah akan kirim ke orang lain
                      CheckboxListTile(
                        title: Text('Kirim ke orang lain juga?'),
                        value: isChecked,
                        onChanged: (bool? value) {
                          // Gunakan setModalState untuk memperbarui status di dalam modal
                          setModalState(() {
                            isChecked = value ?? false;
                          });
                        },
                      ),
                      SizedBox(height: 10),

                      // Dropdown hanya muncul jika checkbox dicentang
                      isChecked
                          ? Column(
                              children: [
                                DropdownButtonFormField<String>(
                                  dropdownColor: Color(0xFFECFFDC),
                                  isExpanded: false,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  icon: Icon(CupertinoIcons
                                      .person_2_square_stack_fill),
                                  elevation: 5,
                                  hint: Text('Pilih Pilihan'),
                                  value: jumlahauthor,
                                  onChanged: (String? newValue) {
                                    setModalState(() {
                                      jumlahauthor = newValue;
                                      selectedauthor1 = null;
                                      selectedauthor2 = null;
                                      // Update nilai dropdown
                                    });
                                  },
                                  items: [
                                    '1 Orang',
                                    '2 Orang',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                          value), // Tampilkan nama pengguna
                                    );
                                  }).toList(),
                                ),
                                SizedBox(height: 10),
                                if (jumlahauthor == "1 Orang") ...[
                                  DropdownButtonFormField<String>(
                                    dropdownColor: Color(0xFFECFFDC),
                                    isExpanded: false,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                    icon: Icon(CupertinoIcons.person),
                                    elevation: 5,
                                    hint: Text('Pilih Author'),
                                    value: selectedauthor1,
                                    onChanged: (String? newValue) {
                                      setModalState(() {
                                        selectedauthor1 = newValue;
                                      });
                                    },
                                    items: userNamesList
                                        .where((String value) =>
                                            value != widget.userData.name)
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                            value), // Tampilkan nama pengguna
                                      );
                                    }).toList(),
                                  ),
                                ] else if (jumlahauthor == "2 Orang") ...[
                                  DropdownButtonFormField<String>(
                                    dropdownColor: Color(0xFFECFFDC),
                                    isExpanded: false,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                    icon: Icon(CupertinoIcons.person),
                                    elevation: 5,
                                    hint: Text('Pilih Author'),
                                    value: selectedauthor1,
                                    onChanged: (String? newValue) {
                                      setModalState(() {
                                        selectedauthor1 =
                                            newValue; // Update nilai dropdown
                                      });
                                    },
                                    items: userNamesList
                                        .where((String value) =>
                                            value != selectedauthor2 &&
                                            value != widget.userData.name)
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                            value), // Tampilkan nama pengguna
                                      );
                                    }).toList(),
                                  ),
                                  SizedBox(height: 10),
                                  DropdownButtonFormField<String>(
                                    dropdownColor: Color(0xFFECFFDC),
                                    isExpanded: false,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                    icon: Icon(CupertinoIcons.person_2),
                                    elevation: 5,
                                    hint: Text('Pilih Author ke-2'),
                                    value: selectedauthor2,
                                    onChanged: (String? newValue) {
                                      setModalState(() {
                                        selectedauthor2 =
                                            newValue; // Update nilai dropdown
                                      });
                                    },
                                    items: userNamesList
                                        .where((String value) =>
                                            value != selectedauthor1 &&
                                            value != widget.userData.name)
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                            value), // Tampilkan nama pengguna
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ],
                            )
                          : Container(),
                      SizedBox(height: 10),
                      CustomElevatedButton(
                        text: isloading ? 'Loading...' : 'Submit',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            isSubmitDocument ? null : submitDocumentData();
                          } else {}
                        },
                        color: Colors.green,
                      ), // Jika checkbox tidak dicentang, tidak menampilkan dropdown
                      SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      // Reset semua nilai variabel saat modal ditutup
      setState(() {
        titleController.text = "";
        jumlahauthor = null;
        selectedauthor1 = null;
        selectedauthor2 = null;
        isChecked = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF009E60), // Hijau
                      Color(0xFF9FE2BF), // Putih
                    ],
                    begin: Alignment.topLeft, // Mulai dari pojok kiri atas
                    end: Alignment.bottomRight, // Berakhir di pojok kanan bawah
                  ),
                  borderRadius: BorderRadius.circular(20), // Sudut melengkung
                ),
                child: Glassmorphism(
                  opacity: 0.3,
                  radius: 20,
                  blur: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: screenHeight * 5 / 100,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Color(0xFF6082B6),
                                child: Icon(
                                  CupertinoIcons.person_crop_circle,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Hello Here,',
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500))),
                                  Text(
                                    widget.userData.name,
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              child: Stack(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Icon(
                                      Icons.notifications_outlined,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Positioned(
                                    right: 4,
                                    top: 4,
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('JMO Signing',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold))),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CircularProgressDashboard(
                              number: 5,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(Icons.pause_presentation_outlined),
                                      Container(
                                        width: 100,
                                        child: Text('Need to Sign',
                                            style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold))),
                                      ),
                                      Text('4',
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    ],
                                  ),
                                  Divider(
                                    thickness: 3,
                                    color: Color(0xFF008080),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(Icons.hourglass_bottom),
                                      Container(
                                        width: 100,
                                        child: Text('Waiting for Others',
                                            style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold))),
                                      ),
                                      Text('1',
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8),
              child: Stack(
                children: [
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFE35335), // Hijau
                          Color(0xFFF88379), // Putih
                        ],
                        begin: Alignment.topLeft, // Mulai dari pojok kiri atas
                        end: Alignment
                            .bottomRight, // Berakhir di pojok kanan bawah
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(width: 10),
                          Container(
                            width: 80,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(children: [
                                Text(
                                  '25',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFE35335),
                                    ),
                                  ),
                                ),
                                Text(
                                  'Fri',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFE35335),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(
                                              CupertinoIcons
                                                  .square_arrow_right_fill,
                                              color: Color(0xFF6495ED),
                                            ),
                                            Text(
                                              'Clock In',
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFFE35335),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, bottom: 5),
                                        child: VerticalDivider(),
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(
                                              CupertinoIcons
                                                  .square_arrow_left_fill,
                                              color: Color(0xFF6495ED),
                                            ),
                                            Text(
                                              'Clock Out',
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFFE35335),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        'Office ,West Jakarta',
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showCustomModal,
        backgroundColor: Color(0xFF4682B4), // Warna latar belakang biru
        child: Icon(
          Icons.add, // Ikon plus
          color: Colors.white, // Warna ikon putih
        ),
      ),
    );
  }
}
