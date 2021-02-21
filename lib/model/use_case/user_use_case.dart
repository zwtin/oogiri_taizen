import 'dart:io';

import 'package:meta/meta.dart';
import 'package:oogiritaizen/model/entity/user_entity.dart';

abstract class UserUseCase {
  Stream<UserEntity> getLoginUserStream();

  Future<UserEntity> getLoginUser();

  Future<void> updateUser({
    @required File imageFile,
    @required UserEntity editedUser,
  });

  Future<void> registerUser({
    @required String email,
  });
}
