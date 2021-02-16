import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/ui/bottom_tab/navigator_view_model.dart';

final bottomTabViewModelProvider =
    ChangeNotifierProvider.autoDispose<BottomTabViewModel>(
  (ref) {
    final bottomTabViewModel = BottomTabViewModel(
      ref,
    );
    ref.onDispose(bottomTabViewModel.disposed);
    return bottomTabViewModel;
  },
);

class BottomTabViewModel extends ChangeNotifier {
  BottomTabViewModel(
    this.providerReference,
  );

  final ProviderReference providerReference;

  int selected = 0;

  void tapped(int index) {
    if (selected == index) {
      switch (index) {
        case 0:
          providerReference
              .read(navigatorViewModelProvider('Tab0'))
              .popToRoot();
          break;
        case 1:
          providerReference
              .read(navigatorViewModelProvider('Tab0'))
              .popToRoot();
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
        providerReference.read(navigatorViewModelProvider('Tab0')).pop();
        break;
      case 1:
        providerReference.read(navigatorViewModelProvider('Tab1')).pop();
        break;
    }
  }

  Future<void> disposed() async {
    debugPrint('bottomTab');
  }
}
