import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/domain/entity/login_user.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/entity/user.dart';
import 'package:oogiri_taizen/domain/repository/authentication_repository.dart';
import 'package:oogiri_taizen/domain/repository/storage_repository.dart';
import 'package:oogiri_taizen/domain/repository/user_repository.dart';
import 'package:oogiri_taizen/infra/repository_impl/authentication_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/storage_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/user_repository_impl.dart';

final editProfileUseCaseProvider =
    Provider.autoDispose.family<EditProfileUseCase, UniqueKey>(
  (ref, key) {
    return EditProfileUseCase(
      key,
      ref.watch(authenticationRepositoryProvider),
      ref.watch(storageRepositoryProvider),
      ref.watch(userRepositoryProvider),
    );
  },
);

class EditProfileUseCase extends ChangeNotifier {
  EditProfileUseCase(
    this._key,
    this._authenticationRepository,
    this._storageRepository,
    this._userRepository,
  ) {
    _loginUserSubscription?.cancel();
    _loginUserSubscription =
        _authenticationRepository.getLoginUserStream().listen(
      (_loginUser) async {
        await _userSubscription?.cancel();
        if (_loginUser == null) {
          loginUser = null;
          notifyListeners();
          return;
        }
        _userSubscription = _userRepository
            .getUserStream(id: _loginUser.id)
            .listen((user) async {
          loginUser = _loginUser.copyWith(user: user);
          notifyListeners();
        });
      },
    );
  }

  final AuthenticationRepository _authenticationRepository;
  final StorageRepository _storageRepository;
  final UserRepository _userRepository;

  final UniqueKey _key;
  final _logger = Logger();

  LoginUser? loginUser;

  StreamSubscription<LoginUser?>? _loginUserSubscription;
  StreamSubscription<User?>? _userSubscription;

  Future<Result<void>> updateUser({
    required String newName,
    required String newIntroduction,
    required File? newImageFile,
  }) async {
    if (loginUser == null) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: 'ログインしてください',
        ),
      );
    }
    String? newImageUrl;
    if (newImageFile != null) {
      final uploadImageResult = await _storageRepository.uploadUserImage(
        file: newImageFile,
      );
      if (uploadImageResult is Failure) {
        return Result.failure(
          OTException(
            title: 'エラー',
            text: '画像のアップロードに失敗しました',
          ),
        );
      }
      newImageUrl = (uploadImageResult as Success<String>).value;

      if (loginUser!.imageUrl != null && loginUser!.imageUrl!.isNotEmpty) {
        await _storageRepository.delete(
          url: loginUser!.imageUrl!,
        );
      }
    }
    final updateProfileResult = await _userRepository.updateUser(
      id: loginUser!.id,
      name: newName,
      imageUrl: newImageUrl,
      introduction: newIntroduction,
    );
    if (updateProfileResult is Failure) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: 'プロフィールの更新に失敗しました',
        ),
      );
    }
    return const Result.success(null);
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('EditProfileUseCase dispose $_key');
  }
}
