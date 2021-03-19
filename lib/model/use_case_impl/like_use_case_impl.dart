import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:oogiritaizen/model/repository/authentication_repository.dart';
import 'package:oogiritaizen/model/repository/like_repository.dart';
import 'package:oogiritaizen/model/repository_impl/authentication_repository_impl.dart';
import 'package:oogiritaizen/model/repository_impl/like_repository_impl.dart';
import 'package:oogiritaizen/model/use_case/like_use_case.dart';

final likeUseCaseProvider = Provider.autoDispose.family<LikeUseCase, String>(
  (ref, id) {
    final likeUseCase = LikeUseCaseImpl(
      id,
      ref.watch(authenticationRepositoryProvider),
      ref.watch(likeRepositoryProvider),
    );
    ref.onDispose(likeUseCase.disposed);
    return likeUseCase;
  },
);

class LikeUseCaseImpl implements LikeUseCase {
  LikeUseCaseImpl(
    this.id,
    this.authenticationRepository,
    this.likeRepository,
  );

  final String id;
  final AuthenticationRepository authenticationRepository;
  final LikeRepository likeRepository;

  @override
  Future<bool> getLike({
    @required String answerId,
  }) async {
    final loginUser = authenticationRepository.getLoginUser();
    final isLike = await likeRepository.getLike(
      userId: loginUser.id,
      answerId: answerId,
    );
    return isLike;
  }

  @override
  Future<void> like({
    @required String answerId,
  }) async {
    final loginUser = authenticationRepository.getLoginUser();
    await likeRepository.like(
      userId: loginUser.id,
      answerId: answerId,
    );
  }

  @override
  Future<void> unlike({
    @required String answerId,
  }) async {
    final loginUser = authenticationRepository.getLoginUser();
    await likeRepository.unlike(
      userId: loginUser.id,
      answerId: answerId,
    );
  }

  Future<void> disposed() async {}
}
