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
import 'package:oogiri_taizen/domain/repository/favor_repository.dart';
import 'package:oogiri_taizen/domain/repository/user_repository.dart';
import 'package:oogiri_taizen/infra/repository_impl/authentication_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/favor_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/user_repository_impl.dart';

final favorUseCaseProvider =
    Provider.autoDispose.family<FavorUseCase, UniqueKey>(
  (ref, key) {
    return FavorUseCase(
      key,
      ref.watch(authenticationRepositoryProvider),
      ref.watch(favorRepositoryProvider),
      ref.watch(userRepositoryProvider),
    );
  },
);

class FavorUseCase extends ChangeNotifier {
  FavorUseCase(
    this._key,
    this._authenticationRepository,
    this._favorRepository,
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
  final FavorRepository _favorRepository;
  final UserRepository _userRepository;

  final UniqueKey _key;
  final _logger = Logger();

  LoginUser? loginUser;

  StreamSubscription<LoginUser?>? _loginUserSubscription;
  StreamSubscription<User?>? _userSubscription;

  Future<Result<void>> favor({required Answer answer}) async {
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
          text: '自分のボケはお気に入りできません',
        ),
      );
    }
    if (answer.isFavor) {
      final result = await _favorRepository.unfavor(
        userId: loginUser!.id,
        answerId: answer.id,
      );
      if (result is Failure) {
        return Result.failure(
          OTException(
            title: 'エラー',
            text: 'お気に入りの解除に失敗しました',
          ),
        );
      }
    } else {
      final result = await _favorRepository.favor(
        userId: loginUser!.id,
        answerId: answer.id,
      );
      if (result is Failure) {
        return Result.failure(
          OTException(
            title: 'エラー',
            text: 'お気に入りに失敗しました',
          ),
        );
      }
    }
    return const Result.success(null);
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('FavorUseCase dispose $_key');

    _loginUserSubscription?.cancel();
    _userSubscription?.cancel();
  }
}
