import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jmo_sign/model/user.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:jmo_sign/view/dashboard/document.dart';
import 'package:jmo_sign/view/dashboard/home.dart';

class DashboardScreen extends StatefulWidget {
  final UserData userData;

  const DashboardScreen({Key? key, required this.userData}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    final List<Widget> pages = [
      Homecreen(userData: widget.userData),
      DocumentScreen(),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: pages[selectedIndex],
      bottomNavigationBar: GNav(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          onTabChange: (value) {
            setState(() {
              selectedIndex = value;
            });
          },
          rippleColor: Colors.grey,
          hoverColor: Colors.grey,
          haptic: true,
          tabBorderRadius: 15,
          tabBackgroundColor: Color(0xFF355E3B),
          backgroundColor: Color(0xFF478778),
          color: Color(0xFF98FB98),
          activeColor: Colors.amber,
          iconSize: 24,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          tabs: [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: CupertinoIcons.doc_on_doc,
              text: 'Document',
            ),
          ]),
    );
  }
}
