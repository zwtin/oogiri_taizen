import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meta/meta.dart';

import 'package:oogiritaizen/model/repository/authentication_repository.dart';
import 'package:oogiritaizen/model/repository_impl/authentication_repository_impl.dart';
import 'package:oogiritaizen/model/use_case/authentication_use_case.dart';

final authenticationUseCaseProvider =
    Provider.autoDispose.family<AuthenticationUseCase, String>(
  (ref, id) {
    final authenticationUseCase = AuthenticationUseCaseImpl(
      id,
      ref.watch(authenticationRepositoryProvider),
    );
    ref.onDispose(authenticationUseCase.disposed);
    return authenticationUseCase;
  },
);

class AuthenticationUseCaseImpl implements AuthenticationUseCase {
  AuthenticationUseCaseImpl(
    this.id,
    this.authenticationRepository,
  );

  final String id;
  final AuthenticationRepository authenticationRepository;

  @override
  Future<void> loginWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    try {
      await authenticationRepository.loginWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on Exception catch (error) {}
  }

  @override
  Future<void> loginWithGoogle() async {
    try {
      await authenticationRepository.loginWithGoogle();
    } on Exception catch (error) {}
  }

  @override
  Future<void> sendEmailVerification({
    @required String email,
    @required String password,
  }) async {
    try {
      await authenticationRepository.sendEmailVerification();
    } on Exception catch (error) {}
  }

  @override
  void logout() {
    authenticationRepository.logout();
  }

  Future<void> disposed() async {}
}
