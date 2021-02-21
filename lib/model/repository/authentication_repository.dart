import 'package:meta/meta.dart';

import 'package:oogiritaizen/model/model/login_user_model.dart';

abstract class AuthenticationRepository {
  Stream<LoginUserModel> getLoginUserStream();

  LoginUserModel getLoginUser();

  Future<void> loginWithEmailAndPassword({
    @required String email,
    @required String password,
  });

  Future<void> loginWithCustomToken({
    @required String token,
  });

  Future<void> loginWithGoogle();

  Future<void> loginWithApple();

  Future<void> createUserWithEmailAndPassword({
    @required String email,
    @required String password,
  });

  Future<void> sendEmailVerification();

  Future<void> applyActionCode({
    @required String actionCode,
  });

  Future<void> sendPasswordResetEmail({
    @required String email,
  });

  Future<void> logout();
}
