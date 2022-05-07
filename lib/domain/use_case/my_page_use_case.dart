import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/domain/entity/login_user.dart';
import 'package:oogiri_taizen/domain/repository/authentication_repository.dart';
import 'package:oogiri_taizen/infra/repository_impl/authentication_repository_impl.dart';

final myPageUseCaseProvider =
    ChangeNotifierProvider.autoDispose.family<MyPageUseCase, UniqueKey>(
  (ref, key) {
    return MyPageUseCase(
      key,
      ref.watch(authenticationRepositoryProvider),
    );
  },
);

class MyPageUseCase extends ChangeNotifier {
  MyPageUseCase(
    this._key,
    this._authenticationRepository,
  ) {
    _loginUserSubscription?.cancel();
    _loginUserSubscription =
        _authenticationRepository.getLoginUserStream().listen(
      (loginUser) async {
        isLogin = loginUser != null;
        notifyListeners();
      },
    );
  }

  final AuthenticationRepository _authenticationRepository;

  final UniqueKey _key;
  final _logger = Logger();

  bool isLogin = false;

  StreamSubscription<LoginUser?>? _loginUserSubscription;

  @override
  void dispose() {
    super.dispose();
    _logger.d('MyPageUseCase dispose $_key');

    _loginUserSubscription?.cancel();
  }
}
