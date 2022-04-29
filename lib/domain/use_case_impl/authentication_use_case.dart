import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/domain/repository/authentication_repository.dart';
import 'package:oogiri_taizen/infra/repository_impl/authentication_repository_impl.dart';

final authenticationUseCaseProvider =
    Provider.autoDispose.family<AuthenticationUseCase, UniqueKey>(
  (ref, key) {
    return AuthenticationUseCase(
      key,
      ref.watch(authenticationRepositoryProvider),
    );
  },
);

class AuthenticationUseCase extends ChangeNotifier {
  AuthenticationUseCase(
    this._key,
    this._authenticationRepository,
  );

  final AuthenticationRepository _authenticationRepository;

  final UniqueKey _key;
  final _logger = Logger();

  @override
  void dispose() {
    super.dispose();
    _logger.d('AuthenticationUseCase dispose $_key');
  }
}
