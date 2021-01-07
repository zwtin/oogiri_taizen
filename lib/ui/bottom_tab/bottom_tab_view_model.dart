import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/data/provider/tab_0_navigator.dart';
import 'package:oogiritaizen/data/provider/tab_1_navigator.dart';

final bottomTabViewModelProvider = ChangeNotifierProvider<BottomTabViewModel>(
  (ref) {
    return BottomTabViewModel(
      tab0navigator: ref.read(
        tab0NavigatorProvider,
      ),
      tab1navigator: ref.read(
        tab1NavigatorProvider,
      ),
    );
  },
);

class BottomTabViewModel extends ChangeNotifier {
  BottomTabViewModel({
    @required this.tab0navigator,
    @required this.tab1navigator,
  });
  int selected = 0;
  final Tab0Navigator tab0navigator;
  final Tab1Navigator tab1navigator;

  void tapped(int index) {
    if (selected == index) {
      switch (index) {
        case 0:
          tab0navigator.popToRoot();
          break;
        case 1:
          tab1navigator.popToRoot();
          break;
      }
    } else {
      selected = index;
    }
    notifyListeners();
  }

  void pop() {
    switch (selected) {
      case 0:
        tab0navigator.pop();
        break;
      case 1:
        tab1navigator.pop();
        break;
    }
  }
}
