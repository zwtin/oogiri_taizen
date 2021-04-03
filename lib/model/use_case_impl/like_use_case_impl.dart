import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/model/entity/is_like_entity.dart';
import 'package:oogiritaizen/model/model/is_like_model.dart';
import 'package:oogiritaizen/model/model/login_user_model.dart';

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

  List<StreamController<IsLikeEntity>> list = [];

  @override
  Stream<IsLikeEntity> getLikeStream({
    @required String answerId,
  }) {
    final likeStream = StreamController<IsLikeEntity>();
    list.add(likeStream);

    authenticationRepository.getLoginUserStream().listen(
      (LoginUserModel loginUserModel) {
        if (loginUserModel == null) {
          likeStream.sink.add(null);
        } else {
          likeRepository
              .getLikeStream(
            userId: loginUserModel.id,
            answerId: answerId,
          )
              .listen(
            (IsLikeModel isLikeModel) {
              likeStream.sink.add(IsLikeEntity()..isLike = isLikeModel.isLike);
            },
          );
        }
      },
    );

    return likeStream.stream;
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

  Future<void> disposed() async {
    for (final streamController in list) {
      await streamController.close();
    }
  }
}
