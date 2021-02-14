import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meta/meta.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:oogiritaizen/model/model/login_user_model.dart';
import 'package:oogiritaizen/model/repository/authentication_repository.dart';

final authenticationRepositoryProvider = Provider<AuthenticationRepository>(
  (ref) {
    return AuthenticationRepositoryImpl();
  },
);

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<LoginUserModel> getLoginUserStream() {
    return _firebaseAuth.authStateChanges().map(
      (User user) {
        if (user == null) {
          return null;
        }
        return LoginUserModel()..id = user.uid;
      },
    );
  }

  @override
  LoginUserModel getLoginUser() {
    return LoginUserModel()..id = _firebaseAuth.currentUser.uid;
  }

  @override
  Future<void> loginWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> loginWithGoogle() async {
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

  @override
  Future<void> loginWithApple() async {
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

  @override
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

  @override
  Future<void> createUserWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> sendPasswordResetEmail({
    @required String email,
  }) async {
    await _firebaseAuth.sendPasswordResetEmail(
      email: email,
    );
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
