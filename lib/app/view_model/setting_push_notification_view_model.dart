import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiri_taizen/app/notifer/alert_notifer.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/push_notification_setting.dart';
import 'package:oogiri_taizen/domain/use_case/push_notification_use_case.dart';
import 'package:oogiri_taizen/domain/use_case_impl/push_notification_use_case_impl.dart';

final settingPushNotificationViewModelProvider = ChangeNotifierProvider
    .autoDispose
    .family<SettingPushNotificationViewModel, UniqueKey>(
  (ref, key) {
    final settingPushNotificationViewModel = SettingPushNotificationViewModel(
      key,
      ref.read,
      ref.watch(pushNotificationUseCaseProvider),
    );
    ref.onDispose(settingPushNotificationViewModel.disposed);
    return settingPushNotificationViewModel;
  },
);

class SettingPushNotificationViewModel extends ChangeNotifier {
  SettingPushNotificationViewModel(
    this._key,
    this._reader,
    this._pushNotificationUseCase,
  ) {
    _streamSubscription?.cancel();
    _streamSubscription = _pushNotificationUseCase.getStream().listen(
      (setting) {
        whenLiked = setting?.whenLiked ?? false;
        whenFavored = setting?.whenFavored ?? false;
        notifyListeners();
      },
    );
  }

  final UniqueKey _key;
  final Reader _reader;
  final PushNotificationUseCase _pushNotificationUseCase;

  bool whenLiked = false;
  bool whenFavored = false;

  StreamSubscription<PushNotificationSetting?>? _streamSubscription;

  Future<void> setWhenLiked(bool value) async {
    final result = await _pushNotificationUseCase.setPushNotificationSetting(
      setting: PushNotificationSetting(
        whenLiked: value,
        whenFavored: whenFavored,
      ),
    );
    result.when(
      success: (_) {},
      failure: (exception) {
        if (exception is OTException) {
          final alertMessage = exception.alertMessage ?? '';
          if (alertMessage.isNotEmpty) {
            _reader.call(alertNotiferProvider).show(
                  title: 'エラー',
                  message: alertMessage,
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

  Future<void> setWhenFavored(bool value) async {
    final result = await _pushNotificationUseCase.setPushNotificationSetting(
      setting: PushNotificationSetting(
        whenLiked: whenLiked,
        whenFavored: value,
      ),
    );
    result.when(
      success: (_) {},
      failure: (exception) {
        if (exception is OTException) {
          final alertMessage = exception.alertMessage ?? '';
          if (alertMessage.isNotEmpty) {
            _reader.call(alertNotiferProvider).show(
                  title: 'エラー',
                  message: alertMessage,
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

  Future<void> disposed() async {
    debugPrint('SettingPushNotificationViewModel disposed');
  }
}
