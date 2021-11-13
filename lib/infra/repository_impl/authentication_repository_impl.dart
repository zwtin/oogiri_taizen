import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiri_taizen/domain/entity/login_user.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/repository/authentication_repository.dart';
import 'package:oogiri_taizen/flavors.dart';

final authenticationRepositoryProvider =
    Provider.autoDispose<AuthenticationRepository>(
  (ref) {
    final authenticationRepository = AuthenticationRepositoryImpl();
    ref.onDispose(authenticationRepository.disposed);
    return authenticationRepository;
  },
);

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  AuthenticationRepositoryImpl() {
    _loginUserModelSubscription?.cancel();
    _loginUserModelSubscription = _firebaseAuth.authStateChanges().listen(
      (loginUserModel) async {
        if (loginUserModel == null) {
          _loginUser = null;
          _streamController.sink.add(null);
        } else {
          await _userSubscription?.cancel();
          _userSubscription = _firestore
              .collection('users')
              .doc(loginUserModel.uid)
              .snapshots()
              .listen(
            (snapshot) {
              final data = snapshot.data();
              if (data == null) {
                _loginUser = null;
                _streamController.sink.add(null);
              } else {
                final loginUser = LoginUser(
                  id: loginUserModel.uid,
                  name: data['name'] as String,
                  imageUrl: data['image_url'] as String,
                  introduction: data['introduction'] as String,
                  emailVerified: loginUserModel.emailVerified,
                );
                _loginUser = loginUser;
                _streamController.sink.add(loginUser);
              }
            },
          );
        }
      },
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  LoginUser? _loginUser;
  final _streamController = StreamController<LoginUser?>.broadcast();
  StreamSubscription<dynamic>? _userSubscription;
  StreamSubscription<User?>? _loginUserModelSubscription;

  @override
  String? getLoginUserId() {
    return _firebaseAuth.currentUser?.uid;
  }

  @override
  LoginUser? getLoginUser() {
    return _loginUser;
  }

  @override
  Stream<LoginUser?> getLoginUserStream() {
    return _streamController.stream;
  }

  @override
  Future<Result<void>> refresh() async {
    try {
      await _firebaseAuth.currentUser?.reload();

      await _loginUserModelSubscription?.cancel();
      _loginUserModelSubscription = _firebaseAuth.authStateChanges().listen(
        (loginUserModel) async {
          if (loginUserModel == null) {
            _loginUser = null;
            _streamController.sink.add(null);
          } else {
            await _userSubscription?.cancel();
            _userSubscription = _firestore
                .collection('users')
                .doc(loginUserModel.uid)
                .snapshots()
                .listen(
              (snapshot) {
                final data = snapshot.data();
                if (data == null) {
                  _loginUser = null;
                  _streamController.sink.add(null);
                } else {
                  final loginUser = LoginUser(
                    id: loginUserModel.uid,
                    name: data['name'] as String,
                    imageUrl: data['image_url'] as String,
                    introduction: data['introduction'] as String,
                    emailVerified: loginUserModel.emailVerified,
                  );
                  _loginUser = loginUser;
                  _streamController.sink.add(loginUser);
                }
              },
            );
          }
        },
      );

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
        throw OTException();
      }
      if (user.emailVerified) {
        throw OTException();
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
        throw OTException();
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
          throw OTException();
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
          throw OTException();
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

  Future<void> disposed() async {
    await _streamController.close();
    await _userSubscription?.cancel();
    await _loginUserModelSubscription?.cancel();
    debugPrint('AuthenticationRepositoryImpl disposed');
  }
}
