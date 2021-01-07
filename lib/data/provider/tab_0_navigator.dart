import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final tab0NavigatorProvider = ChangeNotifierProvider<Tab0Navigator>(
  (ref) {
    return Tab0Navigator();
  },
);

class Tab0Navigator extends ChangeNotifier {
  int n = 0;

  void pop() {
    n++;
    notifyListeners();
  }

  void popToRoot() {
    n = 0;
    notifyListeners();
  }
}
