import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

// class AuthServices {
//   // static FirebaseAuth _auth = FirebaseAuth.instance;

//   // // Email & Password Login
//   // static Future<User> SignUp(String email, String password) async {
//   //   try {
//   //     UserCredential result = await _auth.createUserWithEmailAndPassword(
//   //         email: email, password: password);
//   //     FirebaseUser firebaseUser = result.User;

//   //     return firebaseUser;
//   //   } catch (e) {
//   //     print(e.toString());
//   //     return null;
//   //   }
//   // }

//   // static Future<void> signOut() async {
//   //   _auth.signOut();
//   // }

//   // static Stream<User> get firebaseUserStream => _auth.authStateChanges();

//   // Google Sign In
//   signInWithGoogle() async {
//     // begin interactive sign in process
//     final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

//     // obtain auth details from request
//     final GoogleSignInAuthentication gAuth = await gUser!.authentication;
//     // create a new credential for user
//     final credential = GoogleAuthProvider.credential(
//       accessToken: gAuth.accessToken,
//       idToken: gAuth.idToken,
//     );
//     // sign in
//     return await FirebaseAuth.instance.signInWithCredential(credential);
//   }
// }

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._();

  factory FirebaseService() => _instance;

  FirebaseService._();

  Future<FirebaseApp> initialize() async => await Firebase.initializeApp();

  DatabaseReference get databaseRef => FirebaseDatabase.instance.reference();

  initializeApp({required FirebaseOptions options}) {}
}
