import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meta/meta.dart';
import 'package:oogiritaizen/constants.dart';
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
    try {
      return _firebaseAuth.authStateChanges().map(
        (User user) {
          if (user == null) {
            return null;
          }
          return LoginUserModel()..id = user.uid;
        },
      );
    } on Exception catch (error) {
      rethrow;
    }
  }

  @override
  LoginUserModel getLoginUser() {
    try {
      if (_firebaseAuth.currentUser == null) {
        return null;
      } else {
        return LoginUserModel()..id = _firebaseAuth.currentUser.uid;
      }
    } on Exception catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> loginWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on Exception catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> loginWithCustomToken({
    @required String token,
  }) async {
    try {
      await _firebaseAuth.signInWithCustomToken(token);
    } on Exception catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> loginWithGoogle() async {
    try {
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
    } on Exception catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> loginWithApple() async {
    try {
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
    } on Exception catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> createUserWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on Exception catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      final user = _firebaseAuth.currentUser;
      final token = await user.getIdToken();
      if (!user.emailVerified) {
        final actionCodeSettings = ActionCodeSettings(
          url: Constants.of().flavor == Flavor.development
              ? 'https://oogiri-taizen-dev.firebaseapp.com/?token=$token'
              : 'https://oogiri-taizen.firebaseapp.com/?token=$token',
          dynamicLinkDomain: Constants.of().flavor == Flavor.development
              ? 'oogiritaizendev.page.link'
              : 'oogiritaizen.page.link',
          iOSBundleId: Constants.of().flavor == Flavor.development
              ? 'com.zwtin.oogiritaizen.dev'
              : 'com.zwtin.oogiritaizen',
          androidPackageName: Constants.of().flavor == Flavor.development
              ? 'com.zwtin.oogiritaizen.dev'
              : 'com.zwtin.oogiritaizen',
          androidInstallApp: true,
          androidMinimumVersion: '12',
          handleCodeInApp: true,
        );
        await user.sendEmailVerification(actionCodeSettings);
      }
    } on Exception catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> applyActionCode({@required String actionCode}) async {
    try {
      await _firebaseAuth.checkActionCode(actionCode);
      await _firebaseAuth.applyActionCode(actionCode);
    } on Exception catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> sendPasswordResetEmail({
    @required String email,
  }) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(
        email: email,
      );
    } on Exception catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } on Exception catch (error) {
      rethrow;
    }
  }
}
