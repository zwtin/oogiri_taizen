import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/data/provider/alert.dart';

final bottomTabViewModelProvider = ChangeNotifierProvider<BottomTabViewModel>(
  (ref) {
    return BottomTabViewModel(
      alert: ref.read(
        alertProvider,
      ),
    );
  },
);

class BottomTabViewModel extends ChangeNotifier {
  BottomTabViewModel({@required this.alert});
  int selected = 0;
  final Alert alert;

  void tapped(int index) {
    if (selected == index) {
      alert.show(
        title: 'エラー',
        subtitle: '選択済みのタブです',
        showCancelButton: false,
        onPress: null,
        style: null,
      );
    } else {
      selected = index;
    }
    notifyListeners();
  }
}
