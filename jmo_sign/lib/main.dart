import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jmo_sign/view/auth/login.dart';
import 'package:jmo_sign/view/auth/splashScreen.dart';
import 'service/firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      checkerboardOffscreenLayers: false,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
