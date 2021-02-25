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

final postAnswerViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<PostAnswerViewModel, String>(
  (ref, id) {
    final postAnswerViewModel = PostAnswerViewModel(
      id,
      ref,
      ref.watch(answerUseCaseProvider(id)),
      ref.watch(topicUseCaseProvider(id)),
      ref.watch(userUseCaseProvider(id)),
    );
    ref.onDispose(postAnswerViewModel.disposed);
    return postAnswerViewModel;
  },
);

class PostAnswerViewModel extends ChangeNotifier {
  PostAnswerViewModel(
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

  bool isConnecting = false;
  UserEntity loginUser = UserEntity();
  TopicEntity topic = TopicEntity()..createdUser = UserEntity();
  AnswerEntity editedAnswer = AnswerEntity()
    ..topic = TopicEntity()
    ..createdUser = UserEntity();

  Future<void> setup() async {
    loginUser = await userUseCase.getLoginUser();
    notifyListeners();
  }

  Future<void> getTopic({@required String topicId}) async {
    topic = await topicUseCase.getTopic(topicId: topicId);
    notifyListeners();
  }

  Future<void> postAnswer() async {
    if (editedAnswer.text.isEmpty) {
      // お題本文入力チェック
      providerReference.read(alertViewModelProvider(id)).show(
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
      providerReference.read(alertViewModelProvider(id)).show(
            alertEntity: AlertEntity()
              ..title = '投稿完了'
              ..subtitle = 'お題を投稿しました'
              ..showCancelButton = false
              ..onPress = ((bool b) {
                providerReference.read(navigatorViewModelProvider(id)).pop();
                return b;
              })
              ..style = null,
          );
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

  Future<void> disposed() async {
    debugPrint(id);
  }
}
