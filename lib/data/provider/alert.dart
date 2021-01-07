import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sweetalert/sweetalert.dart';

final alertProvider = ChangeNotifierProvider<Alert>(
  (ref) {
    return Alert();
  },
);

class Alert extends ChangeNotifier {
  String title;
  String subtitle;
  bool showCancelButton;
  SweetAlertOnPress onPress;
  SweetAlertStyle style;

  void show({
    String title,
    String subtitle,
    bool showCancelButton,
    SweetAlertOnPress onPress,
    SweetAlertStyle style,
  }) {
    this.title = title;
    this.subtitle = subtitle;
    this.showCancelButton = showCancelButton;
    this.onPress = onPress;
    this.style = style;
    notifyListeners();
  }
}
