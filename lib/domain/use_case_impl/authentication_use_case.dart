import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/repository/authentication_repository.dart';
import 'package:oogiri_taizen/domain/repository/push_notification_repository.dart';
import 'package:oogiri_taizen/domain/repository/user_repository.dart';
import 'package:oogiri_taizen/infra/repository_impl/authentication_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/push_notification_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/user_repository_impl.dart';

final authenticationUseCaseProvider =
    Provider.autoDispose.family<AuthenticationUseCase, UniqueKey>(
  (ref, key) {
    return AuthenticationUseCase(
      key,
      ref.watch(authenticationRepositoryProvider),
      ref.watch(pushNotificationRepositoryProvider),
      ref.watch(userRepositoryProvider),
    );
  },
);

class AuthenticationUseCase extends ChangeNotifier {
  AuthenticationUseCase(
    this._key,
    this._authenticationRepository,
    this._pushNotificationRepository,
    this._userRepository,
  );

  final AuthenticationRepository _authenticationRepository;
  final PushNotificationRepository _pushNotificationRepository;
  final UserRepository _userRepository;

  final UniqueKey _key;
  final _logger = Logger();

  Future<Result<void>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: 'メールアドレスを入力してください',
        ),
      );
    }
    if (password.isEmpty) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: 'パスワードを入力してください',
        ),
      );
    }
    final result = await _authenticationRepository.loginWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (result is Failure) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: 'ログインに失敗しました',
        ),
      );
    }
    return const Result.success(null);
  }

  Future<Result<void>> loginWithGoogle() async {
    final result = await _authenticationRepository.loginWithGoogle();
    if (result is Failure) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: 'ログインに失敗しました',
        ),
      );
    }
    return const Result.success(null);
  }

  Future<Result<void>> loginWithApple() async {
    final result = await _authenticationRepository.loginWithApple();
    if (result is Failure) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: 'ログインに失敗しました',
        ),
      );
    }
    return const Result.success(null);
  }

  Future<Result<void>> linkWithApple() async {
    final result = await _authenticationRepository.linkWithApple();
    if (result is Failure) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: '連携に失敗しました',
        ),
      );
    }
    return const Result.success(null);
  }

  Future<Result<void>> logout() async {
    final result = await _authenticationRepository.logout();
    if (result is Failure) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: 'ログアウトできませんでした',
        ),
      );
    }
    return const Result.success(null);
  }

  Future<Result<void>> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: 'メールアドレスを入力してください',
        ),
      );
    }
    if (password.isEmpty) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: 'パスワードを入力してください',
        ),
      );
    }
    final createUserWithEmailAndPasswordResult =
        await _authenticationRepository.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (createUserWithEmailAndPasswordResult is Failure) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: 'ユーザー登録に失敗しました',
        ),
      );
    }
    final loginUser = _authenticationRepository.getLoginUser();
    if (loginUser == null) {
      await _authenticationRepository.deleteLoginUser();
      return Result.failure(
        OTException(
          title: 'エラー',
          text: 'ユーザー登録に失敗しました',
        ),
      );
    }
    final createUserResult = await _userRepository.createUser(id: loginUser.id);
    final createPushNotificationResult = await _pushNotificationRepository
        .createPushNotificationSetting(userId: loginUser.id);
    if (createUserResult is Failure ||
        createPushNotificationResult is Failure) {
      await _authenticationRepository.deleteLoginUser();
      return Result.failure(
        OTException(
          title: 'エラー',
          text: 'ユーザー登録に失敗しました',
        ),
      );
    }
    final sendEmailVerificationResult =
        await _authenticationRepository.sendEmailVerification();
    return const Result.success(null);
  }

  Future<Result<void>> sendEmailVerification() async {
    final loginUser = _authenticationRepository.getLoginUser();
    if (loginUser == null) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: 'ログインしてください',
        ),
      );
    }
    final result = await _authenticationRepository.sendEmailVerification();
    if (result is Failure) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: 'メールの送信に失敗しました',
        ),
      );
    }
    return const Result.success(null);
  }

  Future<Result<void>> applyActionCode({
    required String code,
  }) async {
    final loginUser = _authenticationRepository.getLoginUser();
    if (loginUser == null) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: 'ログインしてください',
        ),
      );
    }
    final result = await _authenticationRepository.applyActionCode(code: code);
    if (result is Failure) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: 'リンクの実行に失敗しました',
        ),
      );
    }
    return const Result.success(null);
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('AuthenticationUseCase dispose $_key');
  }
}
