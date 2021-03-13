import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/model/entity/alert_entity.dart';
import 'package:oogiritaizen/model/use_case/answer_use_case.dart';
import 'package:oogiritaizen/model/use_case/topic_use_case.dart';
import 'package:oogiritaizen/model/use_case/user_use_case.dart';

import 'package:oogiritaizen/model/entity/answer_entity.dart';
import 'package:oogiritaizen/model/entity/topic_entity.dart';
import 'package:oogiritaizen/model/entity/user_entity.dart';
import 'package:oogiritaizen/model/use_case_impl/answer_use_case_impl.dart';
import 'package:oogiritaizen/model/use_case_impl/topic_use_case_impl.dart';
import 'package:oogiritaizen/model/use_case_impl/user_use_case_impl.dart';

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
      ref.watch(answerUseCaseProvider(id)),
      ref.watch(topicUseCaseProvider(id)),
      ref.watch(userUseCaseProvider(id)),
    );
    ref.onDispose(answerListViewModel.disposed);
    return answerListViewModel;
  },
);

class AnswerListViewModel extends ChangeNotifier {
  AnswerListViewModel(
    this.id,
    this.providerReference,
    this.answerUseCase,
    this.topicUseCase,
    this.userUseCase,
  ) {
    setup();
  }

  final String id;
  final ProviderReference providerReference;

  final AnswerUseCase answerUseCase;
  final TopicUseCase topicUseCase;
  final UserUseCase userUseCase;

  UserEntity loginUser = UserEntity();

  bool isConnectingInNew = false;
  List<AnswerEntity> newAnswers = [];
  bool hasNextInNew = false;

  bool isConnectingInPopular = false;
  List<AnswerEntity> popularAnswers = [];
  bool hasNextInPopular = false;

  Future<void> setup() async {
    loginUser = await userUseCase.getLoginUser();
    notifyListeners();
  }

  Future<void> refreshNewAnswerList() async {
    newAnswers = [];
    await getNewAnswerList();
  }

  Future<void> getNewAnswerList() async {
    if (isConnectingInNew) {
      return;
    }
    isConnectingInNew = true;
    notifyListeners();
    try {
      final lastAnswerDate =
          newAnswers.isNotEmpty ? newAnswers.last.createdAt : null;
      final answerListEntity =
          await answerUseCase.getNewAnswerList(beforeTime: lastAnswerDate);
      newAnswers.addAll(answerListEntity.answers);
      hasNextInNew = answerListEntity.hasNext;
      isConnectingInNew = false;
      notifyListeners();
    } on Exception catch (error) {
      isConnectingInNew = false;
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
