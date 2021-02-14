import 'package:meta/meta.dart';

abstract class AuthenticationUseCase {
  Future<void> loginWithEmailAndPassword({
    @required String email,
    @required String password,
  });

  Future<void> loginWithGoogle();

  Future<void> sendLoginEmail({
    @required String email,
  });

  void logout();
}
