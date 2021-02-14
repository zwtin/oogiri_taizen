import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:oogiritaizen/model/entity/user_entity.dart';
import 'package:oogiritaizen/model/model/login_user_model.dart';
import 'package:oogiritaizen/model/model/user_model.dart';
import 'package:oogiritaizen/model/repository/authentication_repository.dart';
import 'package:oogiritaizen/model/repository/user_repository.dart';
import 'package:oogiritaizen/model/repository_impl/authentication_repository_impl.dart';
import 'package:oogiritaizen/model/repository_impl/user_repository_impl.dart';
import 'package:oogiritaizen/model/use_case/user_use_case.dart';

final userUseCaseProvider = Provider.autoDispose.family<UserUseCase, String>(
  (ref, id) {
    final userUseCase = UserUseCaseImpl(
      id,
      ref.watch(authenticationRepositoryProvider),
      ref.watch(userRepositoryProvider),
    );
    ref.onDispose(userUseCase.disposed);
    return userUseCase;
  },
);

class UserUseCaseImpl implements UserUseCase {
  UserUseCaseImpl(
    this.id,
    this.authenticationRepository,
    this.userRepository,
  );

  final String id;
  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;

  List<StreamController<UserEntity>> list = [];

  @override
  Stream<UserEntity> getLoginUserStream() {
    final loginUserStream = StreamController<UserEntity>();
    list.add(loginUserStream);

    authenticationRepository.getLoginUserStream().listen(
      (LoginUserModel loginUserModel) {
        if (loginUserModel == null) {
          loginUserStream.sink.add(null);
        } else {
          userRepository.getUserStream(userId: loginUserModel.id).listen(
            (UserModel userModel) {
              debugPrint(id.toString());
              loginUserStream.sink.add(
                UserEntity()
                  ..id = userModel.id
                  ..name = userModel.name
                  ..introduction = userModel.introduction
                  ..imageUrl = userModel.imageUrl,
              );
            },
          );
        }
      },
    );

    return loginUserStream.stream;
  }

  Future<void> disposed() async {
    for (final streamController in list) {
      await streamController.close();
    }
  }
}
