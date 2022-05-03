import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/app/notifer/router_notifer.dart';
import 'package:oogiri_taizen/app/view/block_list_view.dart';
import 'package:oogiri_taizen/app/view/setting_push_notification_view.dart';
import 'package:oogiri_taizen/app/view/terms_of_service_view.dart';
import 'package:oogiri_taizen/domain/use_case/setting_use_case.dart';

final settingViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<SettingViewModel, UniqueKey>(
  (ref, key) {
    return SettingViewModel(
      key,
      ref.read,
      ref.watch(settingUseCaseProvider(key)),
    );
  },
);

class SettingViewModel extends ChangeNotifier {
  SettingViewModel(
    this._key,
    this._reader,
    this._settingUseCase,
  );

  final UniqueKey _key;
  final Reader _reader;
  final _logger = Logger();

  final SettingUseCase _settingUseCase;

  bool get isLogin {
    return _settingUseCase.loginUser != null;
  }

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

  @override
  void dispose() {
    super.dispose();
    _logger.d('SignInViewModel dispose $_key');
  }
}
