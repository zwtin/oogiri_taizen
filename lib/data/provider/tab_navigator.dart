import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final tabNavigatorProvider = ChangeNotifierProvider<TabNavigator>(
  (ref) {
    return TabNavigator();
  },
);

class TabNavigator extends ChangeNotifier {
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
