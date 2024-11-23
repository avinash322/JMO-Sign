import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jmo_sign/view/auth/register.dart';
import 'package:jmo_sign/view/dashboard/dashboard.dart';

import '../../component/button.dart';
import '../../component/textfield.dart';
import '../../model/user.dart';
import '../../service/auth/loginService.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final TextEditingController emailController =
      TextEditingController(text: "avinash@gmail.com");
  final TextEditingController passwordController =
      TextEditingController(text: "avinash");
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  late AnimationController _controller;
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void login() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
    });

    final String email = emailController.text;
    final String password = passwordController.text;

    UserData? user = await _authService.loginWithEmailPassword(email, password);

    setState(() {
      _isLoading = false;
    });

    if (user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DashboardScreen(
                  userData: user,
                )),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Login failed. Please check your credentials.'),
            showCloseIcon: true,
            closeIconColor: Colors.red),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/logo.jpg',
                width: 200,
                height: 200,
                alignment: Alignment.center,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Login',
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold))),
                      Text('silahkan login untuk masuk aplikasi',
                          textAlign: TextAlign.start,
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ))),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        controller: emailController,
                        labelText: 'Email Anda',
                        hintText: 'Email Anda',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 15),
                      CustomTextField(
                        controller: passwordController,
                        labelText: 'Kata Sandi',
                        hintText: 'Kata Sandi',
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            color: Colors.green,
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Lupa Akun?',
                                textAlign: TextAlign.start,
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Colors.red,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500))),
                            Text('Lupa Kata Sandi?',
                                textAlign: TextAlign.start,
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Colors.red,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500))),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      CustomElevatedButton(
                        text: _isLoading ? 'Loading...' : 'Login',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _isLoading ? null : login();
                          } else {}
                        },
                        color: Colors.green,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () => {
                              emailController.clear(),
                              passwordController.clear(),
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterScreen()),
                              )
                            },
                            child: Text('Buat Akun',
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Colors.green,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500))),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Icon(
                  Icons.keyboard_arrow_up,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    height: 5,
                    width: 50,
                    decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10))),
                SizedBox(
                  height: 15,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Pendaftaran Kepesertaan',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.green,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text('Ayo Daftar Kepesertaan BPJAMSOSTEK Sekarang!',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
