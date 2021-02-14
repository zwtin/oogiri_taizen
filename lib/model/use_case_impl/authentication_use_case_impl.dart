import 'package:hooks_riverpod/hooks_riverpod.dart';

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
  void logout() {
    authenticationRepository.logout();
  }

  Future<void> disposed() async {}
}
