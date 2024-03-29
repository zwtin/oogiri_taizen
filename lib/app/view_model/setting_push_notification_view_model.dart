import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/app/notifer/alert_notifer.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/push_notification_setting.dart';
import 'package:oogiri_taizen/domain/use_case/push_notification_setting_use_case.dart';

final settingPushNotificationViewModelProvider = ChangeNotifierProvider
    .autoDispose
    .family<SettingPushNotificationViewModel, UniqueKey>(
  (ref, key) {
    return SettingPushNotificationViewModel(
      key,
      ref.read,
      ref.watch(pushNotificationSettingUseCaseProvider(key)),
    );
  },
);

class SettingPushNotificationViewModel extends ChangeNotifier {
  SettingPushNotificationViewModel(
    this._key,
    this._reader,
    this._pushNotificationSettingUseCase,
  );

  final UniqueKey _key;
  final Reader _reader;
  final _logger = Logger();

  final PushNotificationSettingUseCase _pushNotificationSettingUseCase;

  bool get whenLiked {
    return _pushNotificationSettingUseCase.pushNotificationSetting.whenLiked;
  }

  bool get whenFavored {
    return _pushNotificationSettingUseCase.pushNotificationSetting.whenFavored;
  }

  Future<void> setWhenLiked({required bool newValue}) async {
    final result =
        await _pushNotificationSettingUseCase.updatePushNotificationSetting(
      pushNotificationSetting: PushNotificationSetting(
        whenLiked: newValue,
        whenFavored: whenFavored,
      ),
    );
    result.when(
      success: (_) {},
      failure: (exception) {
        if (exception is OTException) {
          final alertTitle = exception.title;
          final alertText = exception.text;
          if (alertTitle.isNotEmpty && alertText.isNotEmpty) {
            _reader.call(alertNotiferProvider).show(
                  title: alertTitle,
                  message: alertText,
                  okButtonTitle: 'OK',
                  cancelButtonTitle: null,
                  okButtonAction: () {
                    _reader.call(alertNotiferProvider).dismiss();
                  },
                  cancelButtonAction: null,
                );
          }
        }
      },
    );
  }

  Future<void> setWhenFavored({required bool newValue}) async {
    final result =
        await _pushNotificationSettingUseCase.updatePushNotificationSetting(
      pushNotificationSetting: PushNotificationSetting(
        whenLiked: whenLiked,
        whenFavored: newValue,
      ),
    );
    result.when(
      success: (_) {},
      failure: (exception) {
        if (exception is OTException) {
          final alertTitle = exception.title;
          final alertText = exception.text;
          if (alertTitle.isNotEmpty && alertText.isNotEmpty) {
            _reader.call(alertNotiferProvider).show(
                  title: alertTitle,
                  message: alertText,
                  okButtonTitle: 'OK',
                  cancelButtonTitle: null,
                  okButtonAction: () {
                    _reader.call(alertNotiferProvider).dismiss();
                  },
                  cancelButtonAction: null,
                );
          }
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('SettingPushNotificationViewModel dispose $_key');
  }
}
