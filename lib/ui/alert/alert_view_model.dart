import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meta/meta.dart';

import 'package:oogiritaizen/model/entity/alert_entity.dart';

final alertViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<AlertViewModel, String>(
  (ref, screenId) {
    final alertViewModel = AlertViewModel(screenId);
    ref.onDispose(alertViewModel.disposed);
    return alertViewModel;
  },
);

class AlertViewModel extends ChangeNotifier {
  AlertViewModel(this.screenId);

  final String screenId;

  AlertEntity alertEntity;

  void show({
    @required AlertEntity alertEntity,
  }) {
    this.alertEntity = alertEntity;
    notifyListeners();
  }

  Future<void> disposed() async {
    debugPrint(screenId);
  }
}
