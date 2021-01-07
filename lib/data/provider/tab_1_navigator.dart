import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final tab1NavigatorProvider = ChangeNotifierProvider<Tab1Navigator>(
  (ref) {
    return Tab1Navigator();
  },
);

class Tab1Navigator extends ChangeNotifier {
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
