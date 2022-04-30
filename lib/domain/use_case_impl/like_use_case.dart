import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/domain/entity/answer.dart';
import 'package:oogiri_taizen/domain/entity/login_user.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/entity/user.dart';
import 'package:oogiri_taizen/domain/repository/authentication_repository.dart';
import 'package:oogiri_taizen/domain/repository/like_repository.dart';
import 'package:oogiri_taizen/domain/repository/user_repository.dart';
import 'package:oogiri_taizen/infra/repository_impl/authentication_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/like_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/user_repository_impl.dart';

final likeUseCaseProvider = Provider.autoDispose.family<LikeUseCase, UniqueKey>(
  (ref, key) {
    return LikeUseCase(
      key,
      ref.watch(authenticationRepositoryProvider),
      ref.watch(likeRepositoryProvider),
      ref.watch(userRepositoryProvider),
    );
  },
);

class LikeUseCase extends ChangeNotifier {
  LikeUseCase(
    this._key,
    this._authenticationRepository,
    this._likeRepository,
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
  final LikeRepository _likeRepository;
  final UserRepository _userRepository;

  final UniqueKey _key;
  final _logger = Logger();

  LoginUser? loginUser;

  StreamSubscription<LoginUser?>? _loginUserSubscription;
  StreamSubscription<User?>? _userSubscription;

  Future<Result<void>> like({required Answer answer}) async {
    if (loginUser == null) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: 'ログインが必要です',
        ),
      );
    }
    if (answer.createdUserId == loginUser!.id) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: '自分のボケはイイね！できません',
        ),
      );
    }
    if (answer.isLike) {
      final result = await _likeRepository.unlike(
        userId: loginUser!.id,
        answerId: answer.id,
      );
      if (result is Failure) {
        return Result.failure(
          OTException(
            title: 'エラー',
            text: 'イイね！の解除に失敗しました',
          ),
        );
      }
    } else {
      final result = await _likeRepository.like(
        userId: loginUser!.id,
        answerId: answer.id,
      );
      if (result is Failure) {
        return Result.failure(
          OTException(
            title: 'エラー',
            text: 'イイね！に失敗しました',
          ),
        );
      }
    }
    return const Result.success(null);
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('LikeUseCase dispose $_key');

    _loginUserSubscription?.cancel();
    _userSubscription?.cancel();
  }
}
