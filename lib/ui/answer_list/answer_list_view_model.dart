import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:oogiritaizen/ui/alert/alert_view_model.dart';
import 'package:oogiritaizen/ui/bottom_tab/navigator_view_model.dart';
import 'package:oogiritaizen/ui/post_topic/post_topic_view.dart';
import 'package:oogiritaizen/ui/topic_list/topic_list_view.dart';

final answerListViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<AnswerListViewModel, String>(
  (ref, id) {
    final answerListViewModel = AnswerListViewModel(
      id,
      ref.watch(alertViewModelProvider(id)),
      ref.watch(navigatorViewModelProvider('Tab0')),
    );
    ref.onDispose(answerListViewModel.disposed);
    return answerListViewModel;
  },
);

class AnswerListViewModel extends ChangeNotifier {
  AnswerListViewModel(
    this.id,
    this.alertViewModel,
    this.navigatorViewModel,
  );

  final String id;
  final AlertViewModel alertViewModel;
  final NavigatorViewModel navigatorViewModel;

  void transitionToPostTopic() {
    navigatorViewModel.present(
      PostTopicView(),
    );
  }

  void transitionToTopicList() {
    navigatorViewModel.present(
      TopicListView(),
    );
  }

  Future<void> disposed() async {
    debugPrint(id);
  }
}
