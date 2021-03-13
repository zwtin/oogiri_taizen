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

final answerDetailViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<AnswerDetailViewModel, String>(
  (ref, id) {
    final answerDetailViewModel = AnswerDetailViewModel(
      id,
      ref,
      ref.watch(answerUseCaseProvider(id)),
      ref.watch(userUseCaseProvider(id)),
    );
    ref.onDispose(answerDetailViewModel.disposed);
    return answerDetailViewModel;
  },
);

class AnswerDetailViewModel extends ChangeNotifier {
  AnswerDetailViewModel(
    this.id,
    this.providerReference,
    this.answerUseCase,
    this.userUseCase,
  ) {
    setup();
  }

  final String id;
  final ProviderReference providerReference;
  final AnswerUseCase answerUseCase;
  final UserUseCase userUseCase;

  UserEntity loginUser = UserEntity();
  AnswerEntity answer = AnswerEntity()
    ..topic = TopicEntity()
    ..createdUser = UserEntity();

  Future<void> setup() async {
    loginUser = await userUseCase.getLoginUser();
    notifyListeners();
  }

  Future<void> getAnswer({@required String answerId}) async {
    answer = await answerUseCase.getAnswer(answerId: answerId);
    notifyListeners();
  }

  Future<void> disposed() async {
    debugPrint(id);
  }
}
