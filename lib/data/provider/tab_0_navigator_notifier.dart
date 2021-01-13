import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final tab0NavigatorNotifierProvider =
    ChangeNotifierProvider<Tab0NavigatorNotifier>(
  (ref) {
    return Tab0NavigatorNotifier();
  },
);

class Tab0NavigatorNotifier extends ChangeNotifier {
  Widget nextWidget;
  bool fullScreen;
  bool toRoot;

  void push(Widget _nextWidget) {
    nextWidget = _nextWidget;
    fullScreen = false;
    toRoot = false;
    notifyListeners();
  }

  void present(Widget _nextWidget) {
    nextWidget = _nextWidget;
    fullScreen = true;
    toRoot = false;
    notifyListeners();
  }

  void pop() {
    nextWidget = null;
    fullScreen = false;
    toRoot = false;
    notifyListeners();
  }

  void popToRoot() {
    nextWidget = null;
    fullScreen = false;
    toRoot = true;
    notifyListeners();
  }
}
