import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:oogiritaizen/model/entity/answer_entity.dart';
import 'package:oogiritaizen/model/entity/topic_entity.dart';
import 'package:oogiritaizen/model/entity/user_entity.dart';
import 'package:oogiritaizen/model/use_case/answer_use_case.dart';
import 'package:oogiritaizen/model/use_case/topic_use_case.dart';
import 'package:oogiritaizen/model/use_case/user_use_case.dart';
import 'package:oogiritaizen/model/use_case_impl/answer_use_case_impl.dart';
import 'package:oogiritaizen/model/use_case_impl/topic_use_case_impl.dart';
import 'package:oogiritaizen/model/use_case_impl/user_use_case_impl.dart';

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

  bool isLoading = false;
  UserEntity loginUser;
  TopicEntity topic;
  AnswerEntity editedAnswer = AnswerEntity();

  Future<void> setup() async {
    loginUser = await userUseCase.getLoginUser();
    notifyListeners();
  }

  Future<void> getTopic({@required String topicId}) async {
    topic = await topicUseCase.getTopic(topicId: topicId);
    notifyListeners();
  }

  Future<void> disposed() async {
    debugPrint(id);
  }
}
