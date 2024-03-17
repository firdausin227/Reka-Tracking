import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rekatracking/mobilepage.dart';
import 'package:rekatracking/view/web/webpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
String? userEmail, name, uid, imageUrl;

Future<User?> signInWithGoogle(BuildContext context) async {
  await Firebase.initializeApp();

  User? user;
  FirebaseAuth auth = FirebaseAuth.instance;

  if (kIsWeb) {
    GoogleAuthProvider authProvider = GoogleAuthProvider();

    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithPopup(authProvider);

      user = userCredential.user;
    } catch (e) {
      print(e);
    }
  } else if (Platform.isAndroid) {
    GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      try {
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    }
  }
  if (user != null) {
    uid = user.uid;
    name = user.displayName;
    userEmail = user.email;
    imageUrl = user.photoURL;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('auth', true);
    print("name: $name");
    print("userEmail: $userEmail");
    print("imageUrl: $imageUrl");

    if (kIsWeb) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WebPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MobilePage()),
      );
    }
  }
  return user;
}

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._();

  factory FirebaseService() => _instance;

  FirebaseService._();

  Future<FirebaseApp> initialize() async => await Firebase.initializeApp();

  DatabaseReference get databaseRef => FirebaseDatabase.instance.reference();

  initializeApp({required FirebaseOptions options}) {}

  // Method untuk menulis data baru
  Future<void> addBarang(
    String nomorBarcode,
    String namaBarang,
    int jumlahBarang,
    String keteranganBarang,
    String statusProsesBarang,
    String tanggalTarget,
  ) async {
    try {
      CollectionReference barangRef =
          FirebaseFirestore.instance.collection('barang');

      await barangRef.add({
        'nomorBarcode': nomorBarcode,
        'namaBarang': namaBarang,
        'jumlahBarang': jumlahBarang,
        'keteranganBarang': keteranganBarang,
        'statusProsesBarang': statusProsesBarang,
        'tanggalTarget': tanggalTarget,
      });
    } catch (e) {
      print('Error adding barang: $e');
    }
  }
}
