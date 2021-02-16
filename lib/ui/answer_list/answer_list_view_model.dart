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
      ref,
    );
    ref.onDispose(answerListViewModel.disposed);
    return answerListViewModel;
  },
);

class AnswerListViewModel extends ChangeNotifier {
  AnswerListViewModel(
    this.id,
    this.providerReference,
  );

  final String id;
  final ProviderReference providerReference;

  void transitionToPostTopic() {
    providerReference.read(navigatorViewModelProvider('Tab0')).present(
          PostTopicView(),
        );
  }

  void transitionToTopicList() {
    providerReference.read(navigatorViewModelProvider('Tab0')).present(
          TopicListView(),
        );
  }

  Future<void> disposed() async {
    debugPrint(id);
  }
}
