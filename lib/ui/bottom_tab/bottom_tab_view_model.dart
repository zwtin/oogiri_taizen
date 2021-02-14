import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/data/provider/tab_0_navigator_notifier.dart';
import 'package:oogiritaizen/data/provider/tab_1_navigator_notifier.dart';

final bottomTabViewModelProvider =
    ChangeNotifierProvider.autoDispose<BottomTabViewModel>(
  (ref) {
    return BottomTabViewModel(
      ref.watch(tab0NavigatorNotifierProvider),
      ref.watch(tab1NavigatorNotifierProvider),
    );
  },
);

class BottomTabViewModel extends ChangeNotifier {
  BottomTabViewModel(
    this.tab0navigatorNotifier,
    this.tab1navigatorNotifier,
  );

  final Tab0NavigatorNotifier tab0navigatorNotifier;
  final Tab1NavigatorNotifier tab1navigatorNotifier;

  int selected = 0;

  void tapped(int index) {
    if (selected == index) {
      switch (index) {
        case 0:
          tab0navigatorNotifier.popToRoot();
          break;
        case 1:
          tab1navigatorNotifier.popToRoot();
          break;
      }
    } else {
      selected = index;
      notifyListeners();
    }
  }

  void pop() {
    switch (selected) {
      case 0:
        tab0navigatorNotifier.pop();
        break;
      case 1:
        tab1navigatorNotifier.pop();
        break;
    }
  }
}
