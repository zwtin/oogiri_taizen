import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/ui/bottom_tab/navigator_view_model.dart';

final bottomTabViewModelProvider =
    ChangeNotifierProvider.autoDispose<BottomTabViewModel>(
  (ref) {
    return BottomTabViewModel(
      ref.watch(navigatorViewModelProvider('Tab0')),
      ref.watch(navigatorViewModelProvider('Tab1')),
    );
  },
);

class BottomTabViewModel extends ChangeNotifier {
  BottomTabViewModel(
    this.tab0NavigatorViewModel,
    this.tab1NavigatorViewModel,
  );

  final NavigatorViewModel tab0NavigatorViewModel;
  final NavigatorViewModel tab1NavigatorViewModel;

  int selected = 0;

  void tapped(int index) {
    if (selected == index) {
      switch (index) {
        case 0:
          tab0NavigatorViewModel.popToRoot();
          break;
        case 1:
          tab1NavigatorViewModel.popToRoot();
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
        tab0NavigatorViewModel.pop();
        break;
      case 1:
        tab1NavigatorViewModel.pop();
        break;
    }
  }
}
