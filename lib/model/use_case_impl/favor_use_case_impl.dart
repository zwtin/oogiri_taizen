import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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

  List<StreamController<bool>> list = [];

  @override
  Stream<bool> getFavorStream({
    @required String answerId,
  }) {
    final favorStream = StreamController<bool>();
    list.add(favorStream);

    authenticationRepository.getLoginUserStream().listen(
      (LoginUserModel loginUserModel) {
        if (loginUserModel == null) {
          favorStream.sink.add(false);
        } else {
          favorRepository
              .getFavorStream(
            userId: loginUserModel.id,
            answerId: answerId,
          )
              .listen(
            (bool isLike) {
              favorStream.sink.add(isLike);
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
    await favorRepository.favor(
      userId: loginUser.id,
      answerId: answerId,
    );
  }

  @override
  Future<void> unfavor({
    @required String answerId,
  }) async {
    final loginUser = authenticationRepository.getLoginUser();
    await favorRepository.unfavor(
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
