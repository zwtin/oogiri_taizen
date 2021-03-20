import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/model/entity/alert_entity.dart';
import 'package:oogiritaizen/model/entity/topic_entity.dart';
import 'package:oogiritaizen/model/extension/string_extension.dart';
import 'package:oogiritaizen/model/use_case/topic_use_case.dart';
import 'package:oogiritaizen/model/use_case_impl/topic_use_case_impl.dart';
import 'package:oogiritaizen/ui/alert/alert_view_model.dart';
import 'package:oogiritaizen/ui/bottom_tab/navigator_view_model.dart';
import 'package:oogiritaizen/ui/post_answer/post_answer_view.dart';
import 'package:oogiritaizen/ui/post_answer/post_answer_view_model.dart';

final topicListViewModelProvider = ChangeNotifierProvider.autoDispose
    .family<TopicListViewModel, TopicListViewModelParameter>(
  (ref, parameter) {
    final topicListViewModel = TopicListViewModel(
      parameter.screenId,
      ref,
      ref.watch(topicUseCaseProvider(parameter.screenId)),
    );
    ref.onDispose(topicListViewModel.disposed);
    return topicListViewModel;
  },
);

class TopicListViewModelParameter {
  TopicListViewModelParameter({
    @required this.screenId,
  });
  final String screenId;
}

class TopicListViewModel extends ChangeNotifier {
  TopicListViewModel(
    this.id,
    this.providerReference,
    this.topicUseCase,
  ) {
    setup();
  }

  final String id;
  final ProviderReference providerReference;
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
      providerReference.read(alertViewModelProvider(id)).show(
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

  void transitionToPostAnswer({@required String topicId}) {
    final parameter = PostAnswerViewModelParameter(
      screenId: StringExtension.randomString(8),
    );
    providerReference.read(navigatorViewModelProvider(id)).push(
          PostAnswerView(parameter),
        );
  }

  Future<void> disposed() async {
    debugPrint(id);
  }
}
