import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiri_taizen/app/mapper/topic_view_data_mapper.dart';
import 'package:oogiri_taizen/app/mapper/user_view_data_mapper.dart';
import 'package:oogiri_taizen/app/view/profile_view.dart';
import 'package:oogiri_taizen/app/view_data/topic_view_data.dart';
import 'package:oogiri_taizen/app/view_data/user_view_data.dart';

import 'package:oogiri_taizen/app/mapper/answer_view_data_mapper.dart';
import 'package:oogiri_taizen/app/view/answer_detail_view.dart';
import 'package:oogiri_taizen/app/notifer/alert_notifer.dart';
import 'package:oogiri_taizen/app/notifer/router_notifer.dart';
import 'package:oogiri_taizen/app/view_data/answer_view_data.dart';
import 'package:oogiri_taizen/domain/entity/answers.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/use_case/authentication_use_case.dart';
import 'package:oogiri_taizen/domain/use_case/block_use_case.dart';
import 'package:oogiri_taizen/domain/use_case/favor_use_case.dart';
import 'package:oogiri_taizen/domain/use_case/like_use_case.dart';
import 'package:oogiri_taizen/domain/use_case/new_answer_use_case.dart';
import 'package:oogiri_taizen/domain/use_case_impl/authentication_use_case_impl.dart';
import 'package:oogiri_taizen/domain/use_case_impl/block_use_case_impl.dart';
import 'package:oogiri_taizen/domain/use_case_impl/favor_use_case_impl.dart';
import 'package:oogiri_taizen/domain/use_case_impl/like_use_case_impl.dart';
import 'package:oogiri_taizen/domain/use_case_impl/new_answer_use_case_impl.dart';

final answerListViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<AnswerListViewModel, UniqueKey>(
  (ref, key) {
    final answerListViewModel = AnswerListViewModel(
      key,
      ref.read,
      ref.watch(authenticationUseCaseProvider),
      ref.watch(blockUseCaseProvider),
      ref.watch(favorUseCaseProvider),
      ref.watch(likeUseCaseProvider),
      ref.watch(newAnswerUseCaseProvider(key)),
    );
    ref.onDispose(answerListViewModel.disposed);
    return answerListViewModel;
  },
);

class AnswerListViewModel extends ChangeNotifier {
  AnswerListViewModel(
    this._key,
    this._reader,
    this._authenticationUseCase,
    this._blockUseCase,
    this._favorUseCase,
    this._likeUseCase,
    this._newAnswerUseCase,
  ) {
    newAnswersSubscription?.cancel();
    newAnswersSubscription = _newAnswerUseCase.getAnswersStream().listen(
      (answers) {
        newAnswers = answers.list.map(
          (answer) {
            return AnswerViewDataMapper.convertToViewData(answer: answer);
          },
        ).toList();
        hasNextInNew = answers.hasNext;
        notifyListeners();
      },
    );
  }

  final UniqueKey _key;
  final Reader _reader;

  final AuthenticationUseCase _authenticationUseCase;
  final BlockUseCase _blockUseCase;
  final FavorUseCase _favorUseCase;
  final LikeUseCase _likeUseCase;
  final NewAnswerUseCase _newAnswerUseCase;

  List<AnswerViewData> newAnswers = [];
  bool hasNextInNew = true;
  StreamSubscription<Answers>? newAnswersSubscription;

  Future<void> resetNewAnswers() async {
    final result = await _newAnswerUseCase.resetAnswers();
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

  // Future<void> resetFavorAnswers() async {
  //   await _userFavorAnswerUseCase.resetAnswers();
  // }

  Future<void> fetchNewAnswers() async {
    final result = await _newAnswerUseCase.fetchAnswers();
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

  // Future<void> fetchFavorAnswers() async {
  //   await _userFavorAnswerUseCase.fetchAnswers();
  // }

  Future<void> likeAnswer(AnswerViewData answerViewData) async {
    final result = await _likeUseCase.like(
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

  Future<void> favorAnswer(AnswerViewData answerViewData) async {
    final result = await _favorUseCase.favor(
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

  Future<void> transitionToAnswerDetail({required String id}) async {
    await _reader.call(routerNotiferProvider(_key)).push(
          nextScreen: AnswerDetailView(
            answerId: id,
          ),
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
    await newAnswersSubscription?.cancel();
    debugPrint('AnswerListViewModel disposed $_key');
  }
}
