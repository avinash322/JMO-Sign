import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../component/button.dart';
import '../../component/textfield.dart';
import '../../service/auth/registerService.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  final authService = AuthService();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void register() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });
    authService.registerWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
        name: passwordController.text,
        context: context);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.green,
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Text('Buat Akun',
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w600))),
                  Text('silahkan mengisi data dengan benar',
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ))),
                ],
              ),
            ),
          ),
          Center(
            child: Container(
              width: screenWidth * 90 / 100,
              height: screenHeight * 60 / 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                      child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          controller: emailController,
                          labelText: 'Email Anda',
                          hintText: 'Email Anda',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 15),
                        CustomTextField(
                          controller: usernameController,
                          labelText: 'Nama Anda',
                          hintText: 'Nama Anda',
                          keyboardType: TextInputType.text,
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
                        SizedBox(height: 10),
                        CustomElevatedButton(
                          text: _isLoading ? 'Loading...' : 'Register',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _isLoading ? null : register();
                            } else {}
                          },
                          color: Colors.green,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(thickness: 3),
                        Center(
                          child: Image.asset(
                            'assets/logo.jpg',
                            width: 130,
                            height: 130,
                          ),
                        ),
                      ],
                    ),
                  ))),
            ),
          ),
        ],
      ),
    );
  }
}
