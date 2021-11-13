import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:oogiri_taizen/app/view_data/alert_view_data.dart';

final alertNotiferProvider = ChangeNotifierProvider.autoDispose<AlertNotifer>(
  (ref) {
    return AlertNotifer();
  },
);

class AlertNotifer extends ChangeNotifier {
  AlertViewData? alertViewData;

  void show({
    required String title,
    required String message,
    required String? okButtonTitle,
    required String? cancelButtonTitle,
    required void Function()? okButtonAction,
    required void Function()? cancelButtonAction,
  }) {
    alertViewData = AlertViewData(
      title: title,
      message: message,
      okButtonTitle: okButtonTitle,
      cancelButtonTitle: cancelButtonTitle,
      okButtonAction: okButtonAction,
      cancelButtonAction: cancelButtonAction,
    );
    notifyListeners();
  }

  void dismiss() {
    alertViewData = null;
    notifyListeners();
  }
}
