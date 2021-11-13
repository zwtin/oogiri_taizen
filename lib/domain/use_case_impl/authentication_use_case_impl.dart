import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiri_taizen/domain/entity/login_user.dart';

import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/repository/authentication_repository.dart';
import 'package:oogiri_taizen/domain/repository/storage_repository.dart';
import 'package:oogiri_taizen/domain/repository/user_repository.dart';
import 'package:oogiri_taizen/domain/use_case/authentication_use_case.dart';
import 'package:oogiri_taizen/infra/repository_impl/authentication_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/storage_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/user_repository_impl.dart';

final authenticationUseCaseProvider =
    Provider.autoDispose<AuthenticationUseCase>(
  (ref) {
    final authenticationUseCase = AuthenticationUseCaseImpl(
      ref.watch(authenticationRepositoryProvider),
      ref.watch(userRepositoryProvider),
      ref.watch(storageRepositoryProvider),
    );
    ref.onDispose(authenticationUseCase.disposed);
    return authenticationUseCase;
  },
);

class AuthenticationUseCaseImpl implements AuthenticationUseCase {
  AuthenticationUseCaseImpl(
    this._authenticationRepository,
    this._userRepository,
    this._storageRepository,
  );

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  final StorageRepository _storageRepository;

  @override
  LoginUser? getLoginUser() {
    return _authenticationRepository.getLoginUser();
  }

  @override
  Stream<LoginUser?> getLoginUserStream() {
    return _authenticationRepository.getLoginUserStream();
  }

  @override
  Future<Result<void>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty) {
      return Result.failure(OTException(alertMessage: 'メールアドレスを入力してください'));
    }
    if (password.isEmpty) {
      return Result.failure(OTException(alertMessage: 'パスワードを入力してください'));
    }
    final result = await _authenticationRepository.loginWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (result is Failure) {
      return Result.failure(OTException(alertMessage: 'ログインに失敗しました'));
    }
    return const Result.success(null);
  }

  @override
  Future<Result<void>> loginWithGoogle() async {
    final result = await _authenticationRepository.loginWithGoogle();
    if (result is Failure) {
      return Result.failure(OTException(alertMessage: 'ログインに失敗しました'));
    }
    return const Result.success(null);
  }

  @override
  Future<Result<void>> loginWithApple() async {
    final result = await _authenticationRepository.loginWithApple();
    if (result is Failure) {
      return Result.failure(OTException(alertMessage: 'ログインに失敗しました'));
    }
    return const Result.success(null);
  }

  @override
  Future<Result<void>> linkWithApple() async {
    final result = await _authenticationRepository.linkWithApple();
    if (result is Failure) {
      return Result.failure(OTException(alertMessage: '連携に失敗しました'));
    }
    return const Result.success(null);
  }

  @override
  Future<Result<void>> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty) {
      return Result.failure(OTException(alertMessage: 'メールアドレスを入力してください'));
    }
    if (password.isEmpty) {
      return Result.failure(OTException(alertMessage: 'パスワードを入力してください'));
    }
    final createUserWithEmailAndPasswordResult =
        await _authenticationRepository.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (createUserWithEmailAndPasswordResult is Failure) {
      return Result.failure(OTException(alertMessage: 'ユーザー登録に失敗しました'));
    }

    final loginUserId = _authenticationRepository.getLoginUserId();
    if (loginUserId == null) {
      await _authenticationRepository.deleteLoginUser();
      return Result.failure(OTException(alertMessage: 'ユーザー登録に失敗しました'));
    }
    final createUserResult = await _userRepository.createUser(id: loginUserId);
    if (createUserResult is Failure) {
      await _authenticationRepository.deleteLoginUser();
      return Result.failure(OTException(alertMessage: 'ユーザー登録に失敗しました'));
    }
    final sendEmailVerificationResult =
        await _authenticationRepository.sendEmailVerification();
    return const Result.success(null);
  }

  @override
  Future<Result<void>> sendEmailVerification() async {
    final loginUser = _authenticationRepository.getLoginUser();
    if (loginUser == null) {
      return Result.failure(OTException(alertMessage: 'ログインしてください'));
    }
    final result = await _authenticationRepository.sendEmailVerification();
    if (result is Failure) {
      return Result.failure(OTException(alertMessage: 'メールの送信に失敗しました'));
    }
    return const Result.success(null);
  }

  @override
  Future<Result<void>> logout() async {
    final loginUser = _authenticationRepository.getLoginUser();
    if (loginUser == null) {
      return Result.failure(OTException(alertMessage: 'すでにログアウト済みです'));
    }
    final result = await _authenticationRepository.logout();
    if (result is Failure) {
      return Result.failure(OTException(alertMessage: 'ログアウトできませんでした'));
    }
    return const Result.success(null);
  }

  @override
  Future<Result<void>> applyActionCode({
    required String code,
  }) async {
    final result = await _authenticationRepository.applyActionCode(code: code);
    if (result is Failure) {
      return Result.failure(OTException(alertMessage: 'リンクの実行に失敗しました'));
    }
    final refreshResult = await _authenticationRepository.refresh();
    if (refreshResult is Failure) {
      return Result.failure(OTException(alertMessage: 'ユーザーの更新に失敗しました'));
    }
    return const Result.success(null);
  }

  @override
  Future<Result<void>> updateUser({
    required String name,
    required String introduction,
    required File? imageFile,
  }) async {
    final loginUser = _authenticationRepository.getLoginUser();
    if (loginUser == null) {
      return Result.failure(OTException(alertMessage: 'ログインしてください'));
    }
    String? imageUrl;
    if (imageFile != null) {
      final uploadImageResult = await _storageRepository.uploadUserImage(
        file: imageFile,
      );
      if (uploadImageResult is Failure) {
        return Result.failure(OTException(alertMessage: '画像のアップロードに失敗しました'));
      }
      imageUrl = (uploadImageResult as Success<String>).value;

      if (loginUser.imageUrl != null && loginUser.imageUrl!.isNotEmpty) {
        await _storageRepository.delete(
          url: loginUser.imageUrl!,
        );
      }
    }
    final updateProfileResult = await _userRepository.updateUser(
      id: loginUser.id,
      name: name,
      imageUrl: imageUrl,
      introduction: introduction,
    );
    if (updateProfileResult is Failure) {
      return Result.failure(OTException(alertMessage: 'プロフィールの更新に失敗しました'));
    }
    return const Result.success(null);
  }

  Future<void> disposed() async {
    debugPrint('AuthenticationUseCaseImpl disposed');
  }
}
