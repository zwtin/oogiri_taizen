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
    await authenticationRepository.loginWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> loginWithGoogle() async {
    await authenticationRepository.loginWithGoogle();
  }

  @override
  Future<void> sendEmailVerification({
    @required String email,
    @required String password,
  }) async {
    await authenticationRepository.sendEmailVerification();
  }

  @override
  void logout() {
    authenticationRepository.logout();
  }

  Future<void> disposed() async {}
}
