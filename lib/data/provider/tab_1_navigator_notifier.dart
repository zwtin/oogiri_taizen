import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final tab1NavigatorNotifierProvider =
    ChangeNotifierProvider<Tab1NavigatorNotifier>(
  (ref) {
    return Tab1NavigatorNotifier();
  },
);

class Tab1NavigatorNotifier extends ChangeNotifier {
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
