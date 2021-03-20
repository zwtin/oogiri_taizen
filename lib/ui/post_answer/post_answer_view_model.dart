import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/model/entity/alert_entity.dart';

import 'package:oogiritaizen/model/entity/answer_entity.dart';
import 'package:oogiritaizen/model/entity/topic_entity.dart';
import 'package:oogiritaizen/model/entity/user_entity.dart';
import 'package:oogiritaizen/model/use_case/answer_use_case.dart';
import 'package:oogiritaizen/model/use_case/topic_use_case.dart';
import 'package:oogiritaizen/model/use_case/user_use_case.dart';
import 'package:oogiritaizen/model/use_case_impl/answer_use_case_impl.dart';
import 'package:oogiritaizen/model/use_case_impl/topic_use_case_impl.dart';
import 'package:oogiritaizen/model/use_case_impl/user_use_case_impl.dart';
import 'package:oogiritaizen/ui/alert/alert_view_model.dart';
import 'package:oogiritaizen/ui/bottom_tab/navigator_view_model.dart';

final postAnswerViewModelProvider = ChangeNotifierProvider.autoDispose
    .family<PostAnswerViewModel, PostAnswerViewModelParameter>(
  (ref, parameter) {
    final postAnswerViewModel = PostAnswerViewModel(
      parameter.screenId,
      parameter.topicId,
      ref,
      ref.watch(answerUseCaseProvider(parameter.screenId)),
      ref.watch(topicUseCaseProvider(parameter.screenId)),
      ref.watch(userUseCaseProvider(parameter.screenId)),
    );
    ref.onDispose(postAnswerViewModel.disposed);
    return postAnswerViewModel;
  },
);

class PostAnswerViewModelParameter {
  PostAnswerViewModelParameter({
    @required this.screenId,
    @required this.topicId,
  });
  final String screenId;
  final String topicId;
}

class PostAnswerViewModel extends ChangeNotifier {
  PostAnswerViewModel(
    this.screenId,
    this.topicId,
    this.providerReference,
    this.answerUseCase,
    this.topicUseCase,
    this.userUseCase,
  ) {
    setup();
  }

  final String screenId;
  final String topicId;
  final ProviderReference providerReference;
  final AnswerUseCase answerUseCase;
  final TopicUseCase topicUseCase;
  final UserUseCase userUseCase;

  bool isConnecting = false;
  UserEntity loginUser;
  TopicEntity topic;
  AnswerEntity editedAnswer = AnswerEntity()
    ..topic = TopicEntity()
    ..createdUser = UserEntity();

  Future<void> setup() async {
    loginUser = await userUseCase.getLoginUser();
    topic = await topicUseCase.getTopic(topicId: topicId);
    notifyListeners();
  }

  Future<void> postAnswer() async {
    if (editedAnswer.text.isEmpty) {
      // お題本文入力チェック
      providerReference.read(alertViewModelProvider(screenId)).show(
            alertEntity: AlertEntity()
              ..title = 'エラー'
              ..subtitle = 'テキストが未入力です'
              ..showCancelButton = false
              ..onPress = null
              ..style = null,
          );
      return;
    }
    try {
      isConnecting = true;
      notifyListeners();

      await answerUseCase.postAnswer(
        topicId: topic.id,
        editedAnswer: editedAnswer,
      );
      isConnecting = false;
      providerReference.read(alertViewModelProvider(screenId)).show(
            alertEntity: AlertEntity()
              ..title = '投稿完了'
              ..subtitle = 'ボケを投稿しました'
              ..showCancelButton = false
              ..onPress = ((bool b) {
                providerReference
                    .read(navigatorViewModelProvider(screenId))
                    .pop();
                return b;
              })
              ..style = null,
          );
      notifyListeners();
    } on Exception catch (error) {
      isConnecting = false;
      providerReference.read(alertViewModelProvider(screenId)).show(
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

  Future<void> disposed() async {
    debugPrint(screenId);
  }
}
