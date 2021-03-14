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

final answerDetailViewModelProvider = ChangeNotifierProvider.autoDispose
    .family<AnswerDetailViewModel, AnswerDetailViewModelParameter>(
  (ref, parameter) {
    final answerDetailViewModel = AnswerDetailViewModel(
      parameter.screenId,
      parameter.answerId,
      ref,
      ref.watch(answerUseCaseProvider(parameter.screenId)),
      ref.watch(userUseCaseProvider(parameter.screenId)),
    );
    ref.onDispose(answerDetailViewModel.disposed);
    return answerDetailViewModel;
  },
);

class AnswerDetailViewModelParameter {
  AnswerDetailViewModelParameter({
    @required this.screenId,
    @required this.answerId,
  });
  final String screenId;
  final String answerId;
}

class AnswerDetailViewModel extends ChangeNotifier {
  AnswerDetailViewModel(
    this.screenId,
    this.answerId,
    this.providerReference,
    this.answerUseCase,
    this.userUseCase,
  ) {
    setup();
  }

  final String screenId;
  final String answerId;

  final ProviderReference providerReference;
  final AnswerUseCase answerUseCase;
  final UserUseCase userUseCase;

  UserEntity loginUser;
  AnswerEntity answer;

  Future<void> setup() async {
    loginUser = await userUseCase.getLoginUser();
    answer = await answerUseCase.getAnswer(answerId: answerId);
    notifyListeners();
  }

  Future<void> disposed() async {
    debugPrint(screenId);
  }
}
