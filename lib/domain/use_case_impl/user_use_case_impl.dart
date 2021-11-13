import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tuple/tuple.dart';
import 'package:oogiri_taizen/domain/entity/user.dart';
import 'package:oogiri_taizen/domain/repository/user_repository.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/use_case/user_use_case.dart';
import 'package:oogiri_taizen/infra/repository_impl/user_repository_impl.dart';

final userUseCaseProvider =
    Provider.autoDispose.family<UserUseCase, Tuple2<UniqueKey, String>>(
  (ref, tuple) {
    final userUseCase = UserUseCaseImpl(
      tuple.item1,
      tuple.item2,
      ref.watch(userRepositoryProvider),
    );
    ref.onDispose(userUseCase.disposed);
    return userUseCase;
  },
);

class UserUseCaseImpl implements UserUseCase {
  UserUseCaseImpl(
    this._key,
    this._id,
    this._userRepository,
  );

  final UniqueKey _key;
  final String _id;

  final UserRepository _userRepository;

  final _streamController = StreamController<User>();

  @override
  Stream<User> getStream() {
    return _streamController.stream;
  }

  @override
  Future<Result<void>> getUser() async {
    final result = await _userRepository.getUser(id: _id);
    if (result is Failure) {
      return Result.failure(OTException(alertMessage: 'ユーザー情報の取得に失敗しました'));
    }
    final user = (result as Success<User>).value;
    _streamController.sink.add(user);
    return const Result.success(null);
  }

  Future<void> disposed() async {
    await _streamController.close();
    debugPrint('UserUseCaseImpl disposed');
  }
}
