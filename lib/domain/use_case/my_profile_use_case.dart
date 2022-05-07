import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/domain/entity/login_user.dart';
import 'package:oogiri_taizen/domain/entity/user.dart';
import 'package:oogiri_taizen/domain/repository/authentication_repository.dart';
import 'package:oogiri_taizen/domain/repository/user_repository.dart';
import 'package:oogiri_taizen/infra/repository_impl/authentication_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/user_repository_impl.dart';

final myProfileUseCaseProvider =
    ChangeNotifierProvider.autoDispose.family<MyProfileUseCase, UniqueKey>(
  (ref, key) {
    return MyProfileUseCase(
      key,
      ref.watch(authenticationRepositoryProvider),
      ref.watch(userRepositoryProvider),
    );
  },
);

class MyProfileUseCase extends ChangeNotifier {
  MyProfileUseCase(
    this._key,
    this._authenticationRepository,
    this._userRepository,
  ) {
    _loginUserSubscription?.cancel();
    _loginUserSubscription =
        _authenticationRepository.getLoginUserStream().listen(
      (_loginUser) async {
        await _userSubscription?.cancel();
        if (_loginUser == null) {
          loginUser = null;
          notifyListeners();
          return;
        }
        _userSubscription = _userRepository
            .getUserStream(id: _loginUser.id)
            .listen((user) async {
          loginUser = _loginUser.copyWith(user: user);
          notifyListeners();
        });
      },
    );
  }

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;

  final UniqueKey _key;
  final _logger = Logger();

  LoginUser? loginUser;

  StreamSubscription<LoginUser?>? _loginUserSubscription;
  StreamSubscription<User?>? _userSubscription;

  @override
  void dispose() {
    super.dispose();
    _logger.d('MyProfileUseCase dispose $_key');

    _loginUserSubscription?.cancel();
    _userSubscription?.cancel();
  }
}
