import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/data/provider/tab_0_navigator_notifier.dart';
import 'package:oogiritaizen/data/provider/tab_1_navigator_notifier.dart';

final bottomTabViewModelProvider = ChangeNotifierProvider<BottomTabViewModel>(
  (ref) {
    return BottomTabViewModel(ref);
  },
);

class BottomTabViewModel extends ChangeNotifier {
  BottomTabViewModel(this.providerReference);

  final ProviderReference providerReference;

  int selected = 0;

  void tapped(int index) {
    if (selected == index) {
      switch (index) {
        case 0:
          providerReference.read(tab0NavigatorNotifierProvider).popToRoot();
          break;
        case 1:
          providerReference.read(tab1NavigatorNotifierProvider).popToRoot();
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
        providerReference.read(tab0NavigatorNotifierProvider).pop();
        break;
      case 1:
        providerReference.read(tab1NavigatorNotifierProvider).pop();
        break;
    }
  }
}
