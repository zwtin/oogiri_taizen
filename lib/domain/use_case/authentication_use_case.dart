import 'dart:io';

import 'package:oogiri_taizen/domain/entity/login_user.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';

abstract class AuthenticationUseCase {
  LoginUser? getLoginUser();
  Stream<LoginUser?> getLoginUserStream();

  Future<Result<void>> loginWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<Result<void>> loginWithGoogle();
  Future<Result<void>> loginWithApple();

  Future<Result<void>> linkWithApple();

  Future<Result<void>> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<Result<void>> sendEmailVerification();
  Future<Result<void>> applyActionCode({
    required String code,
  });

  Future<Result<void>> updateUser({
    required String name,
    required String introduction,
    required File? imageFile,
  });

  Future<Result<void>> logout();
}
