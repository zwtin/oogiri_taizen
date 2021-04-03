import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/model/entity/is_favor_entity.dart';
import 'package:oogiritaizen/model/model/is_favor_model.dart';
import 'package:oogiritaizen/model/model/login_user_model.dart';

import 'package:oogiritaizen/model/repository/authentication_repository.dart';
import 'package:oogiritaizen/model/repository/favor_repository.dart';
import 'package:oogiritaizen/model/repository_impl/authentication_repository_impl.dart';
import 'package:oogiritaizen/model/repository_impl/favor_repository_impl.dart';
import 'package:oogiritaizen/model/use_case/favor_use_case.dart';

final favorUseCaseProvider = Provider.autoDispose.family<FavorUseCase, String>(
  (ref, id) {
    final favorUseCase = FavorUseCaseImpl(
      id,
      ref.watch(authenticationRepositoryProvider),
      ref.watch(favorRepositoryProvider),
    );
    ref.onDispose(favorUseCase.disposed);
    return favorUseCase;
  },
);

class FavorUseCaseImpl implements FavorUseCase {
  FavorUseCaseImpl(
    this.id,
    this.authenticationRepository,
    this.favorRepository,
  );

  final String id;
  final AuthenticationRepository authenticationRepository;
  final FavorRepository favorRepository;

  List<StreamController<IsFavorEntity>> list = [];

  @override
  Stream<IsFavorEntity> getFavorStream({
    @required String answerId,
  }) {
    final favorStream = StreamController<IsFavorEntity>();
    list.add(favorStream);

    authenticationRepository.getLoginUserStream().listen(
      (LoginUserModel loginUserModel) {
        if (loginUserModel == null) {
          favorStream.sink.add(null);
        } else {
          favorRepository
              .getFavorStream(
            userId: loginUserModel.id,
            answerId: answerId,
          )
              .listen(
            (IsFavorModel isFavorModel) {
              favorStream.sink
                  .add(IsFavorEntity()..isFavor = isFavorModel.isFavor);
            },
          );
        }
      },
    );

    return favorStream.stream;
  }

  @override
  Future<void> favor({
    @required String answerId,
  }) async {
    final loginUser = authenticationRepository.getLoginUser();

    try {
      await favorRepository.favor(
        userId: loginUser.id,
        answerId: answerId,
      );
    } on Exception catch (error) {}
  }

  @override
  Future<void> unfavor({
    @required String answerId,
  }) async {
    final loginUser = authenticationRepository.getLoginUser();

    try {
      await favorRepository.unfavor(
        userId: loginUser.id,
        answerId: answerId,
      );
    } on Exception catch (error) {}
  }

  Future<void> disposed() async {
    for (final streamController in list) {
      await streamController.close();
    }
  }
}
