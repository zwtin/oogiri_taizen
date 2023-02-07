import 'package:oogiri_taizen/domain/entity/result.dart';

abstract class AuthenticationRepository {
  Future<Result<String?>> getLoginUserId();
  Future<Result<void>> loginWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<Result<void>> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<Result<void>> sendEmailVerification();
  Future<Result<void>> applyActionCode({
    required String code,
  });

  Future<Result<void>> loginWithGoogle();
  Future<Result<void>> loginWithApple();
  Future<Result<void>> linkWithApple();

  Future<Result<void>> logout();
  Future<Result<void>> deleteLoginUser();
}
