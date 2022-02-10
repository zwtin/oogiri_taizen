import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiri_taizen/app/mapper/login_user_view_data_mapper.dart';
import 'package:oogiri_taizen/app/notifer/router_notifer.dart';
import 'package:oogiri_taizen/app/view/block_list_view.dart';
import 'package:oogiri_taizen/app/view/setting_push_notification_view.dart';
import 'package:oogiri_taizen/app/view/terms_of_service_view.dart';
import 'package:oogiri_taizen/app/view_data/login_user_view_data.dart';
import 'package:oogiri_taizen/domain/entity/login_user.dart';
import 'package:oogiri_taizen/domain/use_case/authentication_use_case.dart';
import 'package:oogiri_taizen/domain/use_case_impl/authentication_use_case_impl.dart';

final settingViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<SettingViewModel, UniqueKey>(
  (ref, key) {
    final settingViewModel = SettingViewModel(
      key,
      ref.read,
      ref.watch(authenticationUseCaseProvider),
    );
    ref.onDispose(settingViewModel.disposed);
    return settingViewModel;
  },
);

class SettingViewModel extends ChangeNotifier {
  SettingViewModel(
    this._key,
    this._reader,
    this._authenticationUseCase,
  ) {
    loginUserSubscription?.cancel();
    loginUserSubscription = _authenticationUseCase.getLoginUserStream().listen(
      (user) async {
        if (user == null) {
          loginUser = null;
          notifyListeners();
        } else {
          loginUser =
              LoginUserViewDataMapper.convertToViewData(loginUser: user);
          notifyListeners();
        }
      },
    );
    final user = _authenticationUseCase.getLoginUser();
    if (user == null) {
      loginUser = null;
      notifyListeners();
    } else {
      loginUser = LoginUserViewDataMapper.convertToViewData(loginUser: user);
      notifyListeners();
    }
  }

  final UniqueKey _key;
  final Reader _reader;

  final AuthenticationUseCase _authenticationUseCase;

  LoginUserViewData? loginUser;
  StreamSubscription<LoginUser?>? loginUserSubscription;

  Future<void> transitionToPushNotification() async {
    await _reader.call(routerNotiferProvider(_key)).push(
          nextScreen: SettingPushNotificationView(),
        );
  }

  Future<void> transitionToBlockList() async {
    await _reader.call(routerNotiferProvider(_key)).push(
          nextScreen: BlockListView(),
        );
  }

  Future<void> transitionToTermsOfService() async {
    await _reader.call(routerNotiferProvider(_key)).present(
          nextScreen: TermsOfServiceView(),
        );
  }

  Future<void> disposed() async {
    debugPrint('SettingViewModel disposed');
  }
}
