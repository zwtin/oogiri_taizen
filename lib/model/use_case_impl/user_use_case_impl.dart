import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:oogiritaizen/model/entity/user_entity.dart';
import 'package:oogiritaizen/model/model/login_user_model.dart';
import 'package:oogiritaizen/model/model/user_model.dart';
import 'package:oogiritaizen/model/repository/authentication_repository.dart';
import 'package:oogiritaizen/model/repository/storage_repository.dart';
import 'package:oogiritaizen/model/repository/user_repository.dart';
import 'package:oogiritaizen/model/repository_impl/authentication_repository_impl.dart';
import 'package:oogiritaizen/model/repository_impl/storage_repository_impl.dart';
import 'package:oogiritaizen/model/repository_impl/user_repository_impl.dart';
import 'package:oogiritaizen/model/use_case/user_use_case.dart';
import 'package:oogiritaizen/model/extension/string_extension.dart';

final userUseCaseProvider = Provider.autoDispose.family<UserUseCase, String>(
  (ref, id) {
    final userUseCase = UserUseCaseImpl(
      id,
      ref.watch(authenticationRepositoryProvider),
      ref.watch(storageRepositoryProvider),
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
    this.storageRepository,
    this.userRepository,
  );

  final String id;
  final AuthenticationRepository authenticationRepository;
  final StorageRepository storageRepository;
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

  @override
  Future<UserEntity> getLoginUser() async {
    final loginUserModel = authenticationRepository.getLoginUser();
    if (loginUserModel == null) {
      return null;
    }
    try {
      final loginUser = await userRepository.getUser(userId: loginUserModel.id);
      return UserEntity()
        ..id = loginUser.id
        ..name = loginUser.name
        ..introduction = loginUser.introduction
        ..imageUrl = loginUser.imageUrl;
    } on Exception catch (error) {}
  }

  @override
  Future<void> updateUser({
    @required File imageFile,
    @required UserEntity editedUser,
  }) async {
    try {
      var uploadedUrl = '';
      if (imageFile != null) {
        uploadedUrl = await storageRepository.upload(
          path: 'images/users',
          file: imageFile,
        );
      }
      await userRepository.updateUser(
        user: UserModel()
          ..id = authenticationRepository.getLoginUser().id
          ..name = editedUser.name
          ..introduction = editedUser.introduction
          ..imageUrl = uploadedUrl.isEmpty ? null : uploadedUrl,
      );
    } on Exception catch (error) {}
  }

  @override
  Future<void> registerUser({
    @required String email,
  }) async {
    try {
      final password = StringExtension.randomString(8);
      await authenticationRepository.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await authenticationRepository.sendEmailVerification();
      await authenticationRepository.logout();
    } on Exception catch (error) {}
  }

  Future<void> disposed() async {
    for (final streamController in list) {
      await streamController.close();
    }
  }
}
