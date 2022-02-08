// import 'dart:async';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:mekancimapp/models/httpexception.dart';
// import 'package:mekancimapp/screens/HomePage/home_screen.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class Auth with ChangeNotifier {
//   final storage = new FlutterSecureStorage();

//   final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
//   final GoogleSignIn googleSignIn = GoogleSignIn();
//   String userUid;
//   String get getUserUid => userUid;
  
 
 

//   Future<void> login(String email, String password, context) async {
//     try {
//       UserCredential userCredential = await firebaseAuth
//           .signInWithEmailAndPassword(email: email, password: password);
     
//       User user = userCredential.user;

//       if (user == null) {
//         throw HttpException('Giriş Yapılamadı');
//       } else {
//         userUid = user.uid;
//         print('this is user id $userUid');

//         Navigator.of(context)
//             .pushReplacement(MaterialPageRoute(builder: (a) => HomeScreen()));
//       }
//       notifyListeners();
//     } catch (error) {
//       throw error;
//     }
//   }

//   Future<void> signup(String email, String password, context) async {
//     try {
//       UserCredential userCredential = await firebaseAuth
//           .createUserWithEmailAndPassword(email: email, password: password);
//       User user = userCredential.user;
//       userUid = user.uid;
//       if (user == null) {
//         throw HttpException('Giriş Yapılamadı');
//       } else {
//         // Navigator.of(context)
//         //     .pushReplacement(MaterialPageRoute(builder: (a) => HomeScreen()));
//       }

//       notifyListeners();
//     } catch (error) {
//       throw error;
//     }
//   }

//   Future<void> logout(BuildContext context) async {
//     firebaseAuth.signOut();

//     // Navigator.pushReplacement(
//     //     context, MaterialPageRoute(builder: (a) => MyApp()));
//     notifyListeners();
//   }

//   Future signInWithGoogle() async {
//     final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
//     final GoogleSignInAuthentication googleSignInAuthentication =
//         await googleSignInAccount.authentication;

//     final AuthCredential authCredential = GoogleAuthProvider.credential(
//       accessToken: googleSignInAuthentication.accessToken,
//       idToken: googleSignInAuthentication.idToken,
//     );

//     final UserCredential userCredential =
//         await firebaseAuth.signInWithCredential(authCredential);

//     final User user = userCredential.user;
//     assert(user.uid != null);
//     userUid = user.uid;
//     print('Google user Udi => $userUid');
//     notifyListeners();
//   }

//   Future signOutWithGoogle() async {
//     return googleSignIn.signOut();
//   }
// }
