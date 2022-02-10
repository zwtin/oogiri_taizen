import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final settingPushNotificationViewModelProvider = ChangeNotifierProvider
    .autoDispose
    .family<SettingPushNotificationViewModel, UniqueKey>(
  (ref, key) {
    final settingPushNotificationViewModel = SettingPushNotificationViewModel(
      key,
      ref.read,
    );
    ref.onDispose(settingPushNotificationViewModel.disposed);
    return settingPushNotificationViewModel;
  },
);

class SettingPushNotificationViewModel extends ChangeNotifier {
  SettingPushNotificationViewModel(
    this._key,
    this._reader,
  );

  final UniqueKey _key;
  final Reader _reader;

  bool whenLiked = true;
  bool whenFavored = true;
  bool whenRecommended = true;

  void setWhenLiked(bool value) {
    whenLiked = value;
    notifyListeners();
  }

  void setWhenFavored(bool value) {
    whenFavored = value;
    notifyListeners();
  }

  void setWhenRecommended(bool value) {
    whenRecommended = value;
    notifyListeners();
  }

  Future<void> disposed() async {
    debugPrint('SettingPushNotificationViewModel disposed');
  }
}
