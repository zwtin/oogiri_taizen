import 'package:oogiri_taizen/domain/entity/login_user.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';

abstract class AuthenticationRepository {
  LoginUser? getLoginUser();
  Stream<LoginUser?> getLoginUserStream();

  Future<Result<void>> refresh();
  Future<Result<void>> applyActionCode({
    required String code,
  });

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
  Future<Result<void>> logout();
  Future<Result<void>> deleteLoginUser();
}
