import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/domain/entity/login_user.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/push_notification_setting.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/entity/user.dart';
import 'package:oogiri_taizen/domain/repository/authentication_repository.dart';
import 'package:oogiri_taizen/domain/repository/push_notification_repository.dart';
import 'package:oogiri_taizen/domain/repository/user_repository.dart';
import 'package:oogiri_taizen/infra/repository_impl/authentication_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/push_notification_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/user_repository_impl.dart';

final pushNotificationSettingUseCaseProvider =
    Provider.autoDispose.family<PushNotificationSettingUseCase, UniqueKey>(
  (ref, key) {
    return PushNotificationSettingUseCase(
      key,
      ref.watch(authenticationRepositoryProvider),
      ref.watch(userRepositoryProvider),
      ref.watch(pushNotificationRepositoryProvider),
    );
  },
);

class PushNotificationSettingUseCase extends ChangeNotifier {
  PushNotificationSettingUseCase(
    this._key,
    this._authenticationRepository,
    this._userRepository,
    this._pushNotificationRepository,
  ) {
    _loginUserSubscription?.cancel();
    _loginUserSubscription =
        _authenticationRepository.getLoginUserStream().listen(
      (loginUser) async {
        await _settingSubscription?.cancel();
        if (loginUser == null) {
          _loginUser = null;
          pushNotificationSetting = const PushNotificationSetting(
            whenLiked: false,
            whenFavored: false,
          );
          notifyListeners();
          return;
        }
        _userSubscription =
            _userRepository.getUserStream(id: loginUser.id).listen((user) {
          _loginUser = loginUser.copyWith(user: user);
          notifyListeners();
        });
        _settingSubscription = _pushNotificationRepository
            .getPushNotificationSetting(userId: loginUser.id)
            .listen((setting) async {
          pushNotificationSetting = setting;
          notifyListeners();
        });
      },
    );
  }

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  final PushNotificationRepository _pushNotificationRepository;

  final UniqueKey _key;
  final _logger = Logger();

  LoginUser? _loginUser;
  PushNotificationSetting pushNotificationSetting =
      const PushNotificationSetting(
    whenLiked: false,
    whenFavored: false,
  );

  StreamSubscription<LoginUser?>? _loginUserSubscription;
  StreamSubscription<User?>? _userSubscription;
  StreamSubscription<PushNotificationSetting?>? _settingSubscription;

  Future<Result<void>> updatePushNotificationSetting(
      {required PushNotificationSetting pushNotificationSetting}) async {
    if (_loginUser == null) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: 'ログインしてください',
        ),
      );
    }
    final result =
        await _pushNotificationRepository.updatePushNotificationSetting(
      userId: _loginUser!.id,
      setting: pushNotificationSetting,
    );
    if (result is Failure) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: '設定の更新に失敗しました',
        ),
      );
    }
    return const Result.success(null);
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('PushNotificationSettingUseCase dispose $_key');

    _loginUserSubscription?.cancel();
    _userSubscription?.cancel();
    _settingSubscription?.cancel();
  }
}
