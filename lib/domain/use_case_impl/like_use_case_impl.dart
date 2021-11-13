import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:oogiri_taizen/domain/entity/answer.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/repository/authentication_repository.dart';
import 'package:oogiri_taizen/domain/repository/like_repository.dart';
import 'package:oogiri_taizen/domain/use_case/like_use_case.dart';
import 'package:oogiri_taizen/infra/repository_impl/authentication_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/like_repository_impl.dart';

final likeUseCaseProvider = Provider.autoDispose<LikeUseCase>(
  (ref) {
    final likeUseCase = LikeUseCaseImpl(
      ref.watch(authenticationRepositoryProvider),
      ref.watch(likeRepositoryProvider),
    );
    ref.onDispose(likeUseCase.disposed);
    return likeUseCase;
  },
);

class LikeUseCaseImpl implements LikeUseCase {
  LikeUseCaseImpl(
    this._authenticationRepository,
    this._likeRepository,
  );

  final AuthenticationRepository _authenticationRepository;
  final LikeRepository _likeRepository;

  @override
  Future<Result<void>> like({required Answer answer}) async {
    final loginUser = _authenticationRepository.getLoginUser();
    if (loginUser == null) {
      return Result.failure(OTException(alertMessage: 'ログインが必要です'));
    }
    if (answer.createdUser.id == loginUser.id) {
      return Result.failure(OTException(alertMessage: '自分のボケはイイね！できません'));
    }
    Result<void> result;
    if (answer.isLike) {
      result = await _likeRepository.unlike(
        userId: loginUser.id,
        answerId: answer.id,
      );
    } else {
      result = await _likeRepository.like(
        userId: loginUser.id,
        answerId: answer.id,
      );
    }
    if (result is Failure) {
      return Result.failure(OTException(alertMessage: 'イイね！に失敗しました'));
    }
    return const Result.success(null);
  }

  Future<void> disposed() async {
    debugPrint('LikeUseCaseImpl disposed');
  }
}
