import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jmo_sign/view/auth/login.dart';

import '../../service/auth/loginService.dart';
import '../dashboard/dashboard.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _navigateToDashboard();
  }

  void _navigateToDashboard() async {
    // Simulasi waktu loading
    await Future.delayed(const Duration(seconds: 3));

    // Mengecek status login dengan Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Jika pengguna sudah login, arahkan ke DashboardScreen
      _authService.AutoLogin(user, context);
    } else {
      // Jika pengguna belum login, arahkan ke LoginScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF478778), // Warna latar belakang
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo atau Gambar
            Image.asset(
              'assets/logo.jpg', // Tambahkan logo Anda di folder assets
              height: 150,
              width: 150,
            ),
            const SizedBox(height: 20),
            // Teks
            const Text(
              'JMO Sign',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            // Circular Progress Indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
