import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/app/mapper/answer_view_data_mapper.dart';
import 'package:oogiri_taizen/app/mapper/topic_view_data_mapper.dart';
import 'package:oogiri_taizen/app/mapper/user_view_data_mapper.dart';
import 'package:oogiri_taizen/app/notifer/alert_notifer.dart';
import 'package:oogiri_taizen/app/notifer/router_notifer.dart';
import 'package:oogiri_taizen/app/view/profile_view.dart';
import 'package:oogiri_taizen/app/view_data/answer_view_data.dart';
import 'package:oogiri_taizen/app/view_data/topic_view_data.dart';
import 'package:oogiri_taizen/app/view_data/user_view_data.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/use_case/answer_detail_use_case.dart';
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

  AnswerViewData? get answer = _answerDetailUseCase.answer

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

  @override
  void dispose() {
    super.dispose();
    _logger.d('AnswerDetailViewModel dispose $_key');
  }
}
