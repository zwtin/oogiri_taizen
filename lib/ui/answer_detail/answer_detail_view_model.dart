import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/model/entity/alert_entity.dart';

import 'package:oogiritaizen/model/entity/answer_entity.dart';
import 'package:oogiritaizen/model/entity/user_entity.dart';
import 'package:oogiritaizen/model/use_case/answer_use_case.dart';
import 'package:oogiritaizen/model/use_case/block_use_case.dart';
import 'package:oogiritaizen/model/use_case/favor_use_case.dart';
import 'package:oogiritaizen/model/use_case/like_use_case.dart';
import 'package:oogiritaizen/model/use_case/user_use_case.dart';
import 'package:oogiritaizen/model/use_case_impl/answer_use_case_impl.dart';
import 'package:oogiritaizen/model/use_case_impl/block_use_case_impl.dart';
import 'package:oogiritaizen/model/use_case_impl/favor_use_case_impl.dart';
import 'package:oogiritaizen/model/use_case_impl/like_use_case_impl.dart';
import 'package:oogiritaizen/model/use_case_impl/user_use_case_impl.dart';
import 'package:oogiritaizen/ui/alert/alert_view_model.dart';

final answerDetailViewModelProvider = ChangeNotifierProvider.autoDispose
    .family<AnswerDetailViewModel, AnswerDetailViewModelParameter>(
  (ref, parameter) {
    final answerDetailViewModel = AnswerDetailViewModel(
      ref,
      parameter.screenId,
      parameter.answerId,
      ref.watch(answerUseCaseProvider(parameter.screenId)),
      ref.watch(blockUseCaseProvider(parameter.screenId)),
      ref.watch(likeUseCaseProvider(parameter.screenId)),
      ref.watch(favorUseCaseProvider(parameter.screenId)),
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
    this.providerReference,
    this.screenId,
    this.answerId,
    this.answerUseCase,
    this.blockUseCase,
    this.likeUseCase,
    this.favorUseCase,
    this.userUseCase,
  ) {
    setup();
  }

  final String screenId;
  final String answerId;

  final ProviderReference providerReference;
  final AnswerUseCase answerUseCase;
  final BlockUseCase blockUseCase;
  final LikeUseCase likeUseCase;
  final FavorUseCase favorUseCase;
  final UserUseCase userUseCase;

  UserEntity loginUser;
  AnswerEntity answer;

  Future<void> setup() async {
    loginUser = await userUseCase.getLoginUser();
    answer = await answerUseCase.getAnswer(answerId: answerId);
    notifyListeners();
  }

  Future<void> addBlockUser({@required String userId}) async {
    await blockUseCase.addBlockUser(userId: userId);
    providerReference.read(alertViewModelProvider(screenId)).show(
          alertEntity: AlertEntity()
            ..title = '完了'
            ..subtitle = 'ブロックリストに追加しました'
            ..showCancelButton = false
            ..onPress = null
            ..style = null,
        );
  }

  Future<void> addBlockAnswer({@required String answerId}) async {
    await blockUseCase.addBlockAnswer(answerId: answerId);
    providerReference.read(alertViewModelProvider(screenId)).show(
          alertEntity: AlertEntity()
            ..title = '完了'
            ..subtitle = 'ブロックリストに追加しました'
            ..showCancelButton = false
            ..onPress = null
            ..style = null,
        );
  }

  Future<void> addBlockTopic({@required String topicId}) async {
    await blockUseCase.addBlockTopic(topicId: topicId);
    providerReference.read(alertViewModelProvider(screenId)).show(
          alertEntity: AlertEntity()
            ..title = '完了'
            ..subtitle = 'ブロックリストに追加しました'
            ..showCancelButton = false
            ..onPress = null
            ..style = null,
        );
  }

  Future<void> likeButtonAction() async {
    try {
      if (answer.isLike) {
        await likeUseCase.unlike(answerId: answer.id);
        answer
          ..isLike = false
          ..likedTime = answer.likedTime - 1;
      } else {
        await likeUseCase.like(answerId: answer.id);
        answer
          ..isLike = true
          ..likedTime = answer.likedTime + 1;
      }
      notifyListeners();
    } on Exception catch (error) {
      providerReference.read(alertViewModelProvider(screenId)).show(
            alertEntity: AlertEntity()
              ..title = 'エラー'
              ..subtitle = '通信エラーが発生しました'
              ..showCancelButton = false
              ..onPress = null
              ..style = null,
          );
    }
  }

  Future<void> favorButtonAction() async {
    try {
      if (answer.isFavor) {
        await favorUseCase.unfavor(answerId: answer.id);
        answer
          ..isFavor = false
          ..favoredTime = answer.favoredTime - 1;
      } else {
        await favorUseCase.favor(answerId: answer.id);
        answer
          ..isFavor = true
          ..favoredTime = answer.favoredTime + 1;
      }
      notifyListeners();
    } on Exception catch (error) {
      providerReference.read(alertViewModelProvider(screenId)).show(
            alertEntity: AlertEntity()
              ..title = 'エラー'
              ..subtitle = '通信エラーが発生しました'
              ..showCancelButton = false
              ..onPress = null
              ..style = null,
          );
    }
  }

  Future<void> disposed() async {
    debugPrint(screenId);
  }
}
