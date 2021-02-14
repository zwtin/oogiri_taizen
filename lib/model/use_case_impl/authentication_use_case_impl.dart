import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:oogiritaizen/model/entity/user_entity.dart';
import 'package:oogiritaizen/model/model/login_user_model.dart';
import 'package:oogiritaizen/model/model/user_model.dart';
import 'package:oogiritaizen/model/repository/authentication_repository.dart';
import 'package:oogiritaizen/model/repository/user_repository.dart';
import 'package:oogiritaizen/model/repository_impl/authentication_repository_impl.dart';
import 'package:oogiritaizen/model/repository_impl/user_repository_impl.dart';
import 'package:oogiritaizen/model/use_case/authentication_use_case.dart';
import 'package:oogiritaizen/model/use_case/user_use_case.dart';

final authenticationUseCaseProvider =
    Provider.autoDispose.family<AuthenticationUseCase, String>(
  (ref, id) {
    return AuthenticationUseCaseImpl(
      id,
      ref.watch(authenticationRepositoryProvider),
    );
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
}
