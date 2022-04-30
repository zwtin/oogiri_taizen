import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiri_taizen/app/mapper/answer_view_data_mapper.dart';
import 'package:oogiri_taizen/app/mapper/topic_view_data_mapper.dart';
import 'package:oogiri_taizen/app/mapper/user_view_data_mapper.dart';
import 'package:oogiri_taizen/app/notifer/alert_notifer.dart';
import 'package:oogiri_taizen/app/notifer/router_notifer.dart';
import 'package:oogiri_taizen/app/view/profile_view.dart';
import 'package:oogiri_taizen/app/view_data/answer_view_data.dart';
import 'package:oogiri_taizen/app/view_data/topic_view_data.dart';
import 'package:oogiri_taizen/app/view_data/user_view_data.dart';
import 'package:oogiri_taizen/domain/entity/answer.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/use_case/answer_use_case.dart';
import 'package:oogiri_taizen/domain/use_case/answer_use_case_impl.dart';
import 'package:oogiri_taizen/domain/use_case/block_use_case.dart';
import 'package:oogiri_taizen/domain/use_case/block_use_case_impl.dart';
import 'package:oogiri_taizen/domain/use_case/favor_use_case.dart';
import 'package:oogiri_taizen/domain/use_case/favor_use_case_impl.dart';
import 'package:oogiri_taizen/domain/use_case/like_use_case.dart';
import 'package:oogiri_taizen/domain/use_case/like_use_case_impl.dart';
import 'package:tuple/tuple.dart';

final answerDetailViewModelProvider = ChangeNotifierProvider.autoDispose
    .family<AnswerDetailViewModel, Tuple2<UniqueKey, String>>(
  (ref, tuple) {
    final answerDetailViewModel = AnswerDetailViewModel(
      tuple.item1,
      ref.read,
      ref.watch(answerUseCaseProvider(tuple)),
      ref.watch(blockUseCaseProvider),
      ref.watch(favorUseCaseProvider),
      ref.watch(likeUseCaseProvider),
    );
    ref.onDispose(answerDetailViewModel.disposed);
    return answerDetailViewModel;
  },
);

class AnswerDetailViewModel extends ChangeNotifier {
  AnswerDetailViewModel(
    this._key,
    this._reader,
    this._answerUseCase,
    this._blockUseCase,
    this._favorUseCase,
    this._likeUseCase,
  ) {
    answerSubscription?.cancel();
    answerSubscription = _answerUseCase.getAnswerStream().listen(
      (_answer) {
        if (_answer == null) {
          answer = null;
          notifyListeners();
        } else {
          answer = AnswerViewDataMapper.convertToViewData(answer: _answer);
          notifyListeners();
        }
      },
    );
  }

  final UniqueKey _key;
  final Reader _reader;

  final AnswerUseCase _answerUseCase;
  final BlockUseCase _blockUseCase;
  final FavorUseCase _favorUseCase;
  final LikeUseCase _likeUseCase;

  AnswerViewData? answer;
  StreamSubscription<Answer?>? answerSubscription;

  Future<void> likeAnswer() async {
    if (answer == null) {
      return;
    }
    final result = await _likeUseCase.like(
      answer: AnswerViewDataMapper.convertToEntity(
        answerViewData: answer!,
      ),
    );
    result.when(
      success: (_) {},
      failure: (exception) {
        if (exception is OTException) {
          final alertMessage = exception.alertMessage ?? '';
          if (alertMessage.isNotEmpty) {
            _reader.call(alertNotiferProvider).show(
                  title: 'エラー',
                  message: alertMessage,
                  okButtonTitle: 'OK',
                  cancelButtonTitle: null,
                  okButtonAction: () {
                    _reader.call(alertNotiferProvider).dismiss();
                  },
                  cancelButtonAction: null,
                );
          }
        }
      },
    );
  }

  Future<void> favorAnswer() async {
    if (answer == null) {
      return;
    }
    final result = await _favorUseCase.favor(
      answer: AnswerViewDataMapper.convertToEntity(
        answerViewData: answer!,
      ),
    );
    result.when(
      success: (_) {},
      failure: (exception) {
        if (exception is OTException) {
          final alertMessage = exception.alertMessage ?? '';
          if (alertMessage.isNotEmpty) {
            _reader.call(alertNotiferProvider).show(
                  title: 'エラー',
                  message: alertMessage,
                  okButtonTitle: 'OK',
                  cancelButtonTitle: null,
                  okButtonAction: () {
                    _reader.call(alertNotiferProvider).dismiss();
                  },
                  cancelButtonAction: null,
                );
          }
        }
      },
    );
  }

  Future<void> addBlockAnswer(AnswerViewData answerViewData) async {
    final result = await _blockUseCase.addAnswer(
      answer: AnswerViewDataMapper.convertToEntity(
        answerViewData: answerViewData,
      ),
    );
    result.when(
      success: (_) {},
      failure: (exception) {
        if (exception is OTException) {
          final alertMessage = exception.alertMessage ?? '';
          if (alertMessage.isNotEmpty) {
            _reader.call(alertNotiferProvider).show(
                  title: 'エラー',
                  message: alertMessage,
                  okButtonTitle: 'OK',
                  cancelButtonTitle: null,
                  okButtonAction: () {
                    _reader.call(alertNotiferProvider).dismiss();
                  },
                  cancelButtonAction: null,
                );
          }
        }
      },
    );
  }

  Future<void> addBlockTopic(TopicViewData topicViewData) async {
    final result = await _blockUseCase.addTopic(
      topic: TopicViewDataMapper.convertToEntity(
        topicViewData: topicViewData,
      ),
    );
    result.when(
      success: (_) {},
      failure: (exception) {
        if (exception is OTException) {
          final alertMessage = exception.alertMessage ?? '';
          if (alertMessage.isNotEmpty) {
            _reader.call(alertNotiferProvider).show(
                  title: 'エラー',
                  message: alertMessage,
                  okButtonTitle: 'OK',
                  cancelButtonTitle: null,
                  okButtonAction: () {
                    _reader.call(alertNotiferProvider).dismiss();
                  },
                  cancelButtonAction: null,
                );
          }
        }
      },
    );
  }

  Future<void> addBlockUser(UserViewData userViewData) async {
    final result = await _blockUseCase.addUser(
      user: UserViewDataMapper.convertToEntity(
        userViewData: userViewData,
      ),
    );
    result.when(
      success: (_) {},
      failure: (exception) {
        if (exception is OTException) {
          final alertMessage = exception.alertMessage ?? '';
          if (alertMessage.isNotEmpty) {
            _reader.call(alertNotiferProvider).show(
                  title: 'エラー',
                  message: alertMessage,
                  okButtonTitle: 'OK',
                  cancelButtonTitle: null,
                  okButtonAction: () {
                    _reader.call(alertNotiferProvider).dismiss();
                  },
                  cancelButtonAction: null,
                );
          }
        }
      },
    );
  }

  Future<void> transitionToImageDetail({
    required String imageUrl,
    required String imageTag,
  }) async {
    if (imageUrl.isEmpty) {
      return;
    }
    await _reader.call(routerNotiferProvider(_key)).presentImage(
          imageUrl: imageUrl,
          imageTag: imageTag,
        );
  }

  Future<void> transitionToProfile({
    required String id,
  }) async {
    await _reader.call(routerNotiferProvider(_key)).push(
          nextScreen: ProfileView(userId: id),
        );
  }

  Future<void> disposed() async {
    await answerSubscription?.cancel();
    debugPrint('AnswerDetailViewModel disposed $_key');
  }
}
