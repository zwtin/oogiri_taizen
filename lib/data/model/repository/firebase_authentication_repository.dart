import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oogiritaizen/data/model/entity/current_user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirebaseAuthenticationRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<CurrentUser> getCurrentUserStream() {
    return _firebaseAuth.authStateChanges().map(
      (User user) {
        if (user == null) {
          return null;
        }
        return CurrentUser()..id = user.uid;
      },
    );
  }

  CurrentUser getCurrentUser() {
    final user = _firebaseAuth.currentUser;
    return CurrentUser()..id = user.uid;
  }

  bool isSignedIn() {
    final user = _firebaseAuth.currentUser;
    return user != null;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> signInWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> sendSignInWithEmailLink({
    @required String email,
  }) async {
    await _firebaseAuth.sendSignInLinkToEmail(
      email: email,
      actionCodeSettings: ActionCodeSettings(
        url: 'https://oogiri-taizen-dev.firebaseapp.com',
        handleCodeInApp: true,
        iOSBundleId: 'com.zwtin.oogiritaizen.dev',
        androidPackageName: 'com.zwtin.oogiritaizen.dev',
      ),
    );
//    await _firebaseAuth.sendSignInWithEmailLink(
//      email: email,
//      url: 'https://flutter-firebase-6f534.firebaseapp.com/',
//      handleCodeInApp: true,
//      iOSBundleID: 'com.zwtin.flutterFirebase',
//      androidPackageName: 'com.zwtin.flutter_firebase',
//      androidInstallIfNotAvailable: true,
//      androidMinimumVersion: '1',
//    );
  }

  Future<void> createUserWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> sendPasswordResetEmail({
    @required String email,
  }) async {
    await _firebaseAuth.sendPasswordResetEmail(
      email: email,
    );
  }

  Future<void> signInWithGoogle() async {
    final _googleSignIn = GoogleSignIn();
    var currentUser = _googleSignIn.currentUser;
    currentUser ??= await _googleSignIn.signInSilently();
    currentUser ??= await _googleSignIn.signIn();
    final googleAuth = await currentUser.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );
    await _firebaseAuth.signInWithCredential(credential);
  }

  Future<void> signInWithApple() async {
    final result = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    switch (result.state) {
      case '':
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: result.identityToken,
          accessToken: result.authorizationCode,
        );
        await _firebaseAuth.signInWithCredential(credential);
        break;
      case 'a':
        throw Exception();
        break;
      default:
        throw Exception();
        break;
    }
  }
}
