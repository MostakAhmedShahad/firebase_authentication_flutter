import 'package:firebase_authentication_flutter/features/app/splash_screen/splash_screen.dart';
import 'package:firebase_authentication_flutter/features/user_auth/presentation/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyAb8rApi3UFwdQqQadDepPbazAW9Mqx50I",
            appId: "1:1005179153071:web:6226cf83ef6d123739825a",
            messagingSenderId: "1005179153071",
            projectId: "flutter-firebase-a72d0"));
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase app',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(
        child: LoginPage(),
      ),
    );
  }
}
