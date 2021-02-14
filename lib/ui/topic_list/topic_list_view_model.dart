import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/model/entity/alert_entity.dart';
import 'package:oogiritaizen/model/entity/topic_entity.dart';
import 'package:oogiritaizen/model/use_case/topic_use_case.dart';
import 'package:oogiritaizen/model/use_case_impl/topic_use_case_impl.dart';
import 'package:oogiritaizen/ui/alert/alert_view_model.dart';
import 'package:oogiritaizen/ui/bottom_tab/navigator_view_model.dart';

final topicListViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<TopicListViewModel, String>(
  (ref, id) {
    return TopicListViewModel(
      id,
      ref.watch(alertViewModelProvider(id)),
      ref.watch(navigatorViewModelProvider(id)),
      ref.watch(topicUseCaseProvider(id)),
    );
  },
);

class TopicListViewModel extends ChangeNotifier {
  TopicListViewModel(
    this.id,
    this.alertViewModel,
    this.navigatorViewModel,
    this.topicUseCase,
  ) {
    setup();
  }

  final String id;
  final AlertViewModel alertViewModel;
  final NavigatorViewModel navigatorViewModel;
  final TopicUseCase topicUseCase;

  bool isConnecting = false;
  List<TopicEntity> items = [];
  bool hasNext = false;

  Future<void> setup() async {
    await getNewTopicList();
  }

  Future<void> refresh() async {
    items = [];
    await getNewTopicList();
  }

  Future<void> getNewTopicList() async {
    if (isConnecting) {
      return;
    }
    isConnecting = true;
    notifyListeners();
    try {
      final lastTopicDate = items.isNotEmpty ? items.last.createdAt : null;
      final topicListEntity =
          await topicUseCase.getNewTopicList(beforeTime: lastTopicDate);
      items.addAll(topicListEntity.topics);
      hasNext = topicListEntity.hasNext;
      isConnecting = false;
      notifyListeners();
    } on Exception catch (error) {
      isConnecting = false;
      alertViewModel.show(
        alertEntity: AlertEntity()
          ..title = 'エラー'
          ..subtitle = '通信エラーが発生しました'
          ..showCancelButton = false
          ..onPress = null
          ..style = null,
      );
      notifyListeners();
    }
  }

  void transitionToPostAnswer() {}
}
