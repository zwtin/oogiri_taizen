import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/domain/entity/login_user.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/repository/authentication_repository.dart';
import 'package:oogiri_taizen/flavors.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

final authenticationRepositoryProvider =
    Provider.autoDispose<AuthenticationRepository>(
  (ref) {
    final authenticationRepository = AuthenticationRepositoryImpl();
    ref.onDispose(authenticationRepository.dispose);
    return authenticationRepository;
  },
);

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final _logger = Logger();
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  LoginUser? getLoginUser() {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      return null;
    }
    return LoginUser(
      id: user.uid,
      emailVerified: user.emailVerified,
    );
  }

  @override
  Stream<LoginUser?> getLoginUserStream() {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) {
        return null;
      }
      return LoginUser(
        id: user.uid,
        emailVerified: user.emailVerified,
      );
    });
  }

  @override
  Future<Result<void>> refresh() async {
    try {
      await _firebaseAuth.currentUser?.reload();
      return const Result.success(null);
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  @override
  Future<Result<void>> applyActionCode({
    required String code,
  }) async {
    try {
      await _firebaseAuth.applyActionCode(code);
      return const Result.success(null);
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  @override
  Future<Result<void>> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return const Result.success(null);
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  @override
  Future<Result<void>> sendEmailVerification() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw OTException(title: 'エラー', text: 'ログインしてください');
      }
      if (user.emailVerified) {
        throw OTException(title: 'エラー', text: 'メールアドレスは認証済みです');
      }
      final actionCodeSettings = ActionCodeSettings(
        url: F.appFlavor == Flavor.DEVELOPMENT
            ? 'https://oogiri-taizen-dev.firebaseapp.com'
            : 'https://oogiri-taizen.firebaseapp.com',
        dynamicLinkDomain: F.appFlavor == Flavor.DEVELOPMENT
            ? 'oogiritaizendev.page.link'
            : 'oogiritaizen.page.link',
        iOSBundleId: F.appFlavor == Flavor.DEVELOPMENT
            ? 'com.zwtin.oogiritaizen.dev'
            : 'com.zwtin.oogiritaizen',
        androidPackageName: F.appFlavor == Flavor.DEVELOPMENT
            ? 'com.zwtin.oogiritaizen.dev'
            : 'com.zwtin.oogiritaizen',
        androidInstallApp: true,
        androidMinimumVersion: '12',
        handleCodeInApp: true,
      );
      await user.sendEmailVerification(actionCodeSettings);
      return const Result.success(null);
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  @override
  Future<Result<void>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return const Result.success(null);
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  @override
  Future<Result<void>> loginWithGoogle() async {
    try {
      final _googleSignIn = GoogleSignIn();
      var currentUser = _googleSignIn.currentUser;
      currentUser ??= await _googleSignIn.signInSilently();
      currentUser ??= await _googleSignIn.signIn();
      if (currentUser == null) {
        throw OTException(title: 'エラー', text: 'Googleログインに失敗しました');
      }
      final googleAuth = await currentUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      await _firebaseAuth.signInWithCredential(credential);
      return const Result.success(null);
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  @override
  Future<Result<void>> loginWithApple() async {
    try {
      final result = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      switch (result.state) {
        case null:
          final oAuthProvider = OAuthProvider('apple.com');
          final credential = oAuthProvider.credential(
            idToken: result.identityToken,
            accessToken: result.authorizationCode,
          );
          await _firebaseAuth.signInWithCredential(credential);
          return const Result.success(null);
        default:
          throw OTException(title: 'エラー', text: 'Appleログインに失敗しました');
      }
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  @override
  Future<Result<void>> linkWithApple() async {
    try {
      final result = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      switch (result.state) {
        case null:
          final oAuthProvider = OAuthProvider('apple.com');
          final credential = oAuthProvider.credential(
            idToken: result.identityToken,
            accessToken: result.authorizationCode,
          );
          await _firebaseAuth.currentUser!.linkWithCredential(credential);
          return const Result.success(null);
        default:
          throw OTException(title: 'エラー', text: 'Appleとの紐付けに失敗しました');
      }
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _firebaseAuth.signOut();
      return const Result.success(null);
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  @override
  Future<Result<void>> deleteLoginUser() async {
    try {
      await _firebaseAuth.currentUser?.delete();
      return const Result.success(null);
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  void dispose() {
    _logger.d('AuthenticationRepositoryImpl dispose');
  }
}
