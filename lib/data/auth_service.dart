//main imports
import 'package:flutter/material.dart';
//firebase auth imports
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
//doc imports
import 'package:mekancimapp/models/httpexception.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth firebaseAuth;
  AuthService(this.firebaseAuth);
  final GoogleSignIn googleSignIn = GoogleSignIn();
  Stream<User> get authStateChanges => firebaseAuth.authStateChanges();
  String userUid;
  String get getUserUid => userUid;

  Future<String> signIn({String email, String password}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      User user = firebaseAuth.currentUser;

      if (user == null) {
        return 'Giriş Yapılamadı';
      } else {
        userUid = user.uid;
        // print('this is user id $userUid');
        return 'giriş yapıldı';
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> signup(String email, String password, context) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;
      userUid = user.uid;
      if (user == null) {
        throw HttpException('Giriş Yapılamadı');
      } else {
        // Navigator.of(context)
        //     .pushReplacement(MaterialPageRoute(builder: (a) => HomeScreen()));
      }

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> logout(BuildContext context) async {
    firebaseAuth.signOut();

    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (a) => MyApp()));
    notifyListeners();
  }

  Future signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential authCredential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential userCredential =
        await firebaseAuth.signInWithCredential(authCredential);

    final User user = userCredential.user;
    assert(user.uid != null);
    userUid = user.uid;
    print('Google user Udi => $userUid');
    notifyListeners();
  }

  Future signOutWithGoogle() async {
    return googleSignIn.signOut();
  }
}
