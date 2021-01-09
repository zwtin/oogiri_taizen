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
  final Alert alert; // アラート表示用

  String userId;
}
