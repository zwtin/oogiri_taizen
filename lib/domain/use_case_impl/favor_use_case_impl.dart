import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:oogiri_taizen/domain/entity/answer.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/repository/authentication_repository.dart';
import 'package:oogiri_taizen/domain/repository/favor_repository.dart';
import 'package:oogiri_taizen/domain/use_case/favor_use_case.dart';
import 'package:oogiri_taizen/infra/repository_impl/authentication_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/favor_repository_impl.dart';

final favorUseCaseProvider = Provider.autoDispose<FavorUseCase>(
  (ref) {
    final favorUseCase = FavorUseCaseImpl(
      ref.watch(authenticationRepositoryProvider),
      ref.watch(favorRepositoryProvider),
    );
    ref.onDispose(favorUseCase.disposed);
    return favorUseCase;
  },
);

class FavorUseCaseImpl implements FavorUseCase {
  FavorUseCaseImpl(
    this._authenticationRepository,
    this._favorRepository,
  );

  final AuthenticationRepository _authenticationRepository;
  final FavorRepository _favorRepository;

  @override
  Future<Result<void>> favor({required Answer answer}) async {
    final loginUser = _authenticationRepository.getLoginUser();
    if (loginUser == null) {
      return Result.failure(OTException(alertMessage: 'ログインが必要です'));
    }
    if (answer.createdUser.id == loginUser.id) {
      return Result.failure(OTException(alertMessage: '自分のボケはお気に入りできません'));
    }
    Result<void> result;
    if (answer.isFavor) {
      result = await _favorRepository.unfavor(
        userId: loginUser.id,
        answerId: answer.id,
      );
    } else {
      result = await _favorRepository.favor(
        userId: loginUser.id,
        answerId: answer.id,
      );
    }
    if (result is Failure) {
      return Result.failure(OTException(alertMessage: 'お気に入りに失敗しました'));
    }
    return const Result.success(null);
  }

  Future<void> disposed() async {
    debugPrint('FavorUseCaseImpl disposed');
  }
}
