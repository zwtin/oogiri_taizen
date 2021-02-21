import 'package:meta/meta.dart';

abstract class AuthenticationUseCase {
  Future<void> loginWithEmailAndPassword({
    @required String email,
    @required String password,
  });

  Future<void> loginWithGoogle();

  Future<void> sendEmailVerification();

  void logout();
}
