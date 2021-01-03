import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final bottomTabViewModelProvider = ChangeNotifierProvider<BottomTabViewModel>(
  (ref) {
    return BottomTabViewModel();
  },
);

class BottomTabViewModel extends ChangeNotifier {
  int selected = 0;

  void tapped(int index) {
    selected = index;
    notifyListeners();
  }
}
