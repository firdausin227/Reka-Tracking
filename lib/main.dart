import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rekatracking/loginpage.dart';
import 'package:rekatracking/view/web/webpage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBSddXtAb1kApC9PIGAyurS-G6dLXwOCz8",
          authDomain: "barcodetracking-c86a7.firebaseapp.com",
          projectId: "barcodetracking-c86a7",
          storageBucket: "barcodetracking-c86a7.appspot.com",
          messagingSenderId: "478391684566",
          appId: "1:478391684566:web:6c1f9d3c75cdc757b6a877"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WebPage(),
    );
  }
}
