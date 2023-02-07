import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/domain/entity/login_user.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/entity/user.dart' as ot;
import 'package:oogiri_taizen/domain/repository/authentication_repository.dart';
import 'package:oogiri_taizen/flavors.dart';
import 'package:oogiri_taizen/infra/dao/user_dao.dart';
import 'package:oogiri_taizen/infra/mapper/user_mapper.dart';
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
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<Result<LoginUser?>> getLoginUser() async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        return const Result.success(null);
      }
      final doc =
          await _firestore.collection('users').doc(currentUser.uid).get();
      final data = doc.data();
      if (data == null) {
        throw OTException(title: 'エラー', text: 'ユーザーの取得に失敗しました');
      }
      final userDAO = UserDAO.fromMap(data);
      final user = UserMapper.mappingFromDAO(userDAO: userDAO);
      return Result.success(
        LoginUser(
          user: user,
          emailVerified: currentUser.emailVerified,
        ),
      );
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  @override
  Stream<LoginUser?> getLoginUserStream() {
    return _firebaseAuth.authStateChanges().asyncMap(
      (currentUser) async {
        if (currentUser == null) {
          return null;
        }
        final doc =
            await _firestore.collection('users').doc(currentUser.uid).get();
        final data = doc.data();
        if (data == null) {
          return null;
        }
        final userDAO = UserDAO.fromMap(data);
        final user = UserMapper.mappingFromDAO(userDAO: userDAO);
        return LoginUser(
          user: user,
          emailVerified: currentUser.emailVerified,
        );
      },
    );
  }

  @override
  Future<Result<void>> applyActionCode({
    required String code,
  }) async {
    try {
      await _firebaseAuth.applyActionCode(code);
      await _firebaseAuth.currentUser?.reload();
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
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        throw OTException(title: 'エラー', text: 'ユーザーの作成に失敗しました');
      }
      final user = ot.User(
        id: currentUser.uid,
        name: '名無し',
        imageUrl: null,
        introduction: 'よろしくお願いします',
      );
      final userDAO = UserMapper.mappingToDAO(user: user);
      final data = userDAO.toMap();
      final ref = _firestore.collection('users').doc(currentUser.uid);
      await _firestore.runTransaction<void>(
        (Transaction transaction) async {
          transaction.set(
            ref,
            data,
          );
        },
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
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        throw OTException(title: 'エラー', text: 'ログインしていません');
      }
      await _firestore.runTransaction<void>(
        (Transaction transaction) async {
          final ref = _firestore.collection('users').doc(currentUser.uid);
          final doc = await transaction.get(ref);
          if (doc.exists) {
            transaction.delete(ref);
          } else {
            throw OTException(title: 'エラー', text: 'ユーザー情報がありません');
          }
        },
      );
      await currentUser.delete();
      return const Result.success(null);
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  void dispose() {
    _logger.d('AuthenticationRepositoryImpl dispose');
  }
}
