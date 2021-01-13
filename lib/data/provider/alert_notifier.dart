import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sweetalert/sweetalert.dart';

final alertNotifierProvider =
    ChangeNotifierProvider.autoDispose.family<AlertNotifier, String>(
  (ref, id) {
    return AlertNotifier(id);
  },
);

class AlertNotifier extends ChangeNotifier {
  AlertNotifier(this.id);

  String id;

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
