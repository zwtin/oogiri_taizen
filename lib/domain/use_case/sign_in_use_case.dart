import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/repository/authentication_repository.dart';
import 'package:oogiri_taizen/infra/repository_impl/authentication_repository_impl.dart';

final signInUseCaseProvider =
    ChangeNotifierProvider.autoDispose.family<SignInUseCase, UniqueKey>(
  (ref, key) {
    return SignInUseCase(
      key,
      ref.watch(authenticationRepositoryProvider),
    );
  },
);

class SignInUseCase extends ChangeNotifier {
  SignInUseCase(
    this._key,
    this._authenticationRepository,
  );

  final AuthenticationRepository _authenticationRepository;

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

  @override
  void dispose() {
    super.dispose();
    _logger.d('SignInUseCase dispose $_key');
  }
}
