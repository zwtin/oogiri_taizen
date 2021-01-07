import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/data/provider/alert.dart';

final myProfileViewModelProvider = ChangeNotifierProvider<MyProfileViewModel>(
  (ref) {
    return MyProfileViewModel(
      alert: ref.read(
        alertProvider,
      ),
    );
  },
);

class MyProfileViewModel extends ChangeNotifier {
  MyProfileViewModel({@required this.alert});
  final Alert alert;

  void tapped() {
    alert.show(
      viewName: 'MyProfileView',
      title: 'エラー',
      subtitle: '選択済みのタブです',
      showCancelButton: false,
      onPress: null,
      style: null,
    );
  }
}
