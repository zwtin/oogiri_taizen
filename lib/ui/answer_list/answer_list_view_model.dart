import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/data/provider/alert.dart';

final answerListViewModelProvider = ChangeNotifierProvider<AnswerListViewModel>(
  (ref) {
    return AnswerListViewModel(
      alert: ref.read(
        alertProvider,
      ),
    );
  },
);

class AnswerListViewModel extends ChangeNotifier {
  AnswerListViewModel({@required this.alert});
  final Alert alert;

  void tapped() {
    alert.show(
      viewName: 'AnswerListView',
      title: 'エラー',
      subtitle: '選択済みのタブです',
      showCancelButton: false,
      onPress: null,
      style: null,
    );
  }
}
