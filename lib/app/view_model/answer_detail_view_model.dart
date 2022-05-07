import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/app/mapper/answer_detail_answer_card_view_data_mapper.dart';
import 'package:oogiri_taizen/app/mapper/answer_detail_topic_card_view_data_mapper.dart';
import 'package:oogiri_taizen/app/notifer/alert_notifer.dart';
import 'package:oogiri_taizen/app/notifer/router_notifer.dart';
import 'package:oogiri_taizen/app/view/user_profile_view.dart';
import 'package:oogiri_taizen/app/view_data/answer_detail_answer_card_view_data.dart';
import 'package:oogiri_taizen/app/view_data/answer_detail_topic_card_view_data.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/use_case/answer_detail_use_case.dart';
import 'package:oogiri_taizen/domain/use_case/block_use_case.dart';
import 'package:oogiri_taizen/domain/use_case/favor_use_case.dart';
import 'package:oogiri_taizen/domain/use_case/like_use_case.dart';
import 'package:tuple/tuple.dart';

final answerDetailViewModelProvider = ChangeNotifierProvider.autoDispose
    .family<AnswerDetailViewModel, Tuple2<UniqueKey, String>>(
  (ref, tuple) {
    return AnswerDetailViewModel(
      tuple.item1,
      ref.read,
      ref.watch(answerDetailUseCaseProvider(tuple)),
      ref.watch(blockUseCaseProvider(tuple.item1)),
      ref.watch(favorUseCaseProvider(tuple.item1)),
      ref.watch(likeUseCaseProvider(tuple.item1)),
    );
  },
);

class AnswerDetailViewModel extends ChangeNotifier {
  AnswerDetailViewModel(
    this._key,
    this._reader,
    this._answerDetailUseCase,
    this._blockUseCase,
    this._favorUseCase,
    this._likeUseCase,
  );

  final UniqueKey _key;
  final Reader _reader;
  final _logger = Logger();

  final AnswerDetailUseCase _answerDetailUseCase;
  final BlockUseCase _blockUseCase;
  final FavorUseCase _favorUseCase;
  final LikeUseCase _likeUseCase;

  AnswerDetailTopicCardViewData? get topicViewData {
    final answer = _answerDetailUseCase.answer;
    if (answer == null) {
      return null;
    }
    return mappingForAnswerDetailTopicCardViewData(answer: answer);
  }

  AnswerDetailAnswerCardViewData? get answerViewData {
    final answer = _answerDetailUseCase.answer;
    if (answer == null) {
      return null;
    }
    return mappingForAnswerDetailAnswerCardViewData(answer: answer);
  }

  Future<void> fetchAnswerDetail() async {
    final result = await _answerDetailUseCase.fetchAnswerDetail();
    result.when(
      success: (_) {
        notifyListeners();
      },
      failure: (exception) {
        if (exception is OTException) {
          final alertTitle = exception.title;
          final alertText = exception.text;
          if (alertTitle.isNotEmpty && alertText.isNotEmpty) {
            _reader.call(alertNotiferProvider).show(
                  title: alertTitle,
                  message: alertText,
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

  Future<void> likeAnswer() async {
    final answer = _answerDetailUseCase.answer;
    if (answer == null) {
      _reader.call(alertNotiferProvider).show(
            title: 'エラー',
            message: 'ボケが見つかりませんでした',
            okButtonTitle: 'OK',
            cancelButtonTitle: null,
            okButtonAction: () {
              _reader.call(alertNotiferProvider).dismiss();
            },
            cancelButtonAction: null,
          );
      return;
    }
    final result = await _likeUseCase.like(answer: answer);
    result.when(
      success: (_) {},
      failure: (exception) {
        if (exception is OTException) {
          final alertTitle = exception.title;
          final alertText = exception.text;
          if (alertTitle.isNotEmpty && alertText.isNotEmpty) {
            _reader.call(alertNotiferProvider).show(
                  title: alertTitle,
                  message: alertText,
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
    final answer = _answerDetailUseCase.answer;
    if (answer == null) {
      _reader.call(alertNotiferProvider).show(
            title: 'エラー',
            message: 'ボケが見つかりませんでした',
            okButtonTitle: 'OK',
            cancelButtonTitle: null,
            okButtonAction: () {
              _reader.call(alertNotiferProvider).dismiss();
            },
            cancelButtonAction: null,
          );
      return;
    }
    final result = await _favorUseCase.favor(answer: answer);
    result.when(
      success: (_) {},
      failure: (exception) {
        if (exception is OTException) {
          final alertTitle = exception.title;
          final alertText = exception.text;
          if (alertTitle.isNotEmpty && alertText.isNotEmpty) {
            _reader.call(alertNotiferProvider).show(
                  title: alertTitle,
                  message: alertText,
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

  Future<void> addBlockAnswer() async {
    final answer = _answerDetailUseCase.answer;
    if (answer == null) {
      _reader.call(alertNotiferProvider).show(
            title: 'エラー',
            message: 'ボケが見つかりませんでした',
            okButtonTitle: 'OK',
            cancelButtonTitle: null,
            okButtonAction: () {
              _reader.call(alertNotiferProvider).dismiss();
            },
            cancelButtonAction: null,
          );
      return;
    }
    final result = await _blockUseCase.addAnswer(answer: answer);
    result.when(
      success: (_) {
        _reader.call(alertNotiferProvider).show(
              title: '完了',
              message: 'ボケをブロックしました',
              okButtonTitle: 'OK',
              cancelButtonTitle: null,
              okButtonAction: () {
                _reader.call(alertNotiferProvider).dismiss();
                _reader.call(routerNotiferProvider(_key)).pop();
              },
              cancelButtonAction: null,
            );
      },
      failure: (exception) {
        if (exception is OTException) {
          final alertTitle = exception.title;
          final alertText = exception.text;
          if (alertTitle.isNotEmpty && alertText.isNotEmpty) {
            _reader.call(alertNotiferProvider).show(
                  title: alertTitle,
                  message: alertText,
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

  Future<void> addBlockTopic() async {
    final topic = _answerDetailUseCase.answer?.topic;
    if (topic == null) {
      _reader.call(alertNotiferProvider).show(
            title: 'エラー',
            message: 'お題が見つかりませんでした',
            okButtonTitle: 'OK',
            cancelButtonTitle: null,
            okButtonAction: () {
              _reader.call(alertNotiferProvider).dismiss();
            },
            cancelButtonAction: null,
          );
      return;
    }
    final result = await _blockUseCase.addTopic(topic: topic);
    result.when(
      success: (_) {
        _reader.call(alertNotiferProvider).show(
              title: '完了',
              message: 'お題をブロックしました',
              okButtonTitle: 'OK',
              cancelButtonTitle: null,
              okButtonAction: () {
                _reader.call(alertNotiferProvider).dismiss();
                _reader.call(routerNotiferProvider(_key)).pop();
              },
              cancelButtonAction: null,
            );
      },
      failure: (exception) {
        if (exception is OTException) {
          final alertTitle = exception.title;
          final alertText = exception.text;
          if (alertTitle.isNotEmpty && alertText.isNotEmpty) {
            _reader.call(alertNotiferProvider).show(
                  title: alertTitle,
                  message: alertText,
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

  Future<void> addBlockAnswerUser() async {
    final user = _answerDetailUseCase.answer?.createdUser;
    if (user == null) {
      _reader.call(alertNotiferProvider).show(
            title: 'エラー',
            message: 'ユーザーが見つかりませんでした',
            okButtonTitle: 'OK',
            cancelButtonTitle: null,
            okButtonAction: () {
              _reader.call(alertNotiferProvider).dismiss();
            },
            cancelButtonAction: null,
          );
      return;
    }
    final result = await _blockUseCase.addUser(user: user);
    result.when(
      success: (_) {
        _reader.call(alertNotiferProvider).show(
              title: '完了',
              message: 'ユーザーをブロックしました',
              okButtonTitle: 'OK',
              cancelButtonTitle: null,
              okButtonAction: () {
                _reader.call(alertNotiferProvider).dismiss();
                _reader.call(routerNotiferProvider(_key)).pop();
              },
              cancelButtonAction: null,
            );
      },
      failure: (exception) {
        if (exception is OTException) {
          final alertTitle = exception.title;
          final alertText = exception.text;
          if (alertTitle.isNotEmpty && alertText.isNotEmpty) {
            _reader.call(alertNotiferProvider).show(
                  title: alertTitle,
                  message: alertText,
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

  Future<void> addBlockTopicUser() async {
    final user = _answerDetailUseCase.answer?.topic?.createdUser;
    if (user == null) {
      _reader.call(alertNotiferProvider).show(
            title: 'エラー',
            message: 'ユーザーが見つかりませんでした',
            okButtonTitle: 'OK',
            cancelButtonTitle: null,
            okButtonAction: () {
              _reader.call(alertNotiferProvider).dismiss();
            },
            cancelButtonAction: null,
          );
      return;
    }
    final result = await _blockUseCase.addUser(user: user);
    result.when(
      success: (_) {
        _reader.call(alertNotiferProvider).show(
              title: '完了',
              message: 'ユーザーをブロックしました',
              okButtonTitle: 'OK',
              cancelButtonTitle: null,
              okButtonAction: () {
                _reader.call(alertNotiferProvider).dismiss();
                _reader.call(routerNotiferProvider(_key)).pop();
              },
              cancelButtonAction: null,
            );
      },
      failure: (exception) {
        if (exception is OTException) {
          final alertTitle = exception.title;
          final alertText = exception.text;
          if (alertTitle.isNotEmpty && alertText.isNotEmpty) {
            _reader.call(alertNotiferProvider).show(
                  title: alertTitle,
                  message: alertText,
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
          nextScreen: UserProfileView(userId: id),
        );
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('AnswerDetailViewModel dispose $_key');
  }
}
