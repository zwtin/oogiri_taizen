import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/data/provider/alert_notifier.dart';
import 'package:oogiritaizen/data/provider/tab_0_navigator_notifier.dart';
import 'package:oogiritaizen/ui/post_answer/post_answer_view.dart';
import 'package:oogiritaizen/ui/post_topic/post_topic_view.dart';

final answerListViewModelProvider =
    ChangeNotifierProvider.family<AnswerListViewModel, String>(
  (ref, id) {
    return AnswerListViewModel(
      ref,
      id,
    );
  },
);

class AnswerListViewModel extends ChangeNotifier {
  AnswerListViewModel(
    this.providerReference,
    this.id,
  );

  final ProviderReference providerReference;
  final String id;

  double getRadiansFromDegree(double degree) {
    const unitRadian = 57.295779513;
    return degree / unitRadian;
  }

  void tapped() {
    providerReference.read(alertNotifierProvider(id)).show(
          title: 'エラー',
          subtitle: '選択済みのタブです',
          showCancelButton: false,
          onPress: null,
          style: null,
        );
  }

  void transitionToPostAnswer() {
    providerReference.read(tab0NavigatorNotifierProvider).present(
          PostAnswerView(),
        );
  }

  void transitionToPostTopic() {
    providerReference.read(tab0NavigatorNotifierProvider).present(
          PostTopicView(),
        );
  }
}
