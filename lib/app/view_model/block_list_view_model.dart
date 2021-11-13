import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiri_taizen/app/mapper/answer_view_data_mapper.dart';
import 'package:oogiri_taizen/app/mapper/topic_view_data_mapper.dart';
import 'package:oogiri_taizen/app/mapper/user_view_data_mapper.dart';
import 'package:oogiri_taizen/app/notifer/alert_notifer.dart';
import 'package:oogiri_taizen/app/view_data/answer_view_data.dart';
import 'package:oogiri_taizen/app/view_data/topic_view_data.dart';
import 'package:oogiri_taizen/app/view_data/user_view_data.dart';
import 'package:oogiri_taizen/domain/entity/answers.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/topics.dart';
import 'package:oogiri_taizen/domain/entity/users.dart';
import 'package:oogiri_taizen/domain/use_case/block_list_use_case.dart';
import 'package:oogiri_taizen/domain/use_case/block_use_case.dart';
import 'package:oogiri_taizen/domain/use_case_impl/block_list_use_case_impl.dart';

final blockListViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<BlockListViewModel, UniqueKey>(
  (ref, key) {
    final blockListViewModel = BlockListViewModel(
      key,
      ref.read,
      ref.watch(blockListUseCaseProvider(key)),
    );
    ref.onDispose(blockListViewModel.disposed);
    return blockListViewModel;
  },
);

class BlockListViewModel extends ChangeNotifier {
  BlockListViewModel(
    this._key,
    this._reader,
    this._blockListUseCase,
  ) {
    blockAnswersSubscription?.cancel();
    blockAnswersSubscription = _blockListUseCase.getAnswersStream().listen(
      (answers) {
        blockAnswers = answers.list.map(
          (answer) {
            return AnswerViewDataMapper.convertToViewData(answer: answer);
          },
        ).toList();
        hasNextInAnswer = answers.hasNext;
        notifyListeners();
      },
    );

    blockTopicsSubscription?.cancel();
    blockTopicsSubscription = _blockListUseCase.getTopicsStream().listen(
      (topics) {
        blockTopics = topics.list.map(
          (topic) {
            return TopicViewDataMapper.convertToViewData(topic: topic);
          },
        ).toList();
        hasNextInTopic = topics.hasNext;
        notifyListeners();
      },
    );

    blockUsersSubscription?.cancel();
    blockUsersSubscription = _blockListUseCase.getUsersStream().listen(
      (users) {
        blockUsers = users.list.map(
          (user) {
            return UserViewDataMapper.convertToViewData(user: user);
          },
        ).toList();
        hasNextInUser = users.hasNext;
        notifyListeners();
      },
    );

    resetBlockAnswers();
    resetBlockTopics();
    resetBlockUsers();
  }

  final UniqueKey _key;
  final Reader _reader;

  final BlockListUseCase _blockListUseCase;

  List<AnswerViewData> blockAnswers = [];
  bool hasNextInAnswer = true;
  StreamSubscription<Answers>? blockAnswersSubscription;

  List<TopicViewData> blockTopics = [];
  bool hasNextInTopic = true;
  StreamSubscription<Topics>? blockTopicsSubscription;

  List<UserViewData> blockUsers = [];
  bool hasNextInUser = true;
  StreamSubscription<Users>? blockUsersSubscription;

  Future<void> resetBlockAnswers() async {
    final result = await _blockListUseCase.resetAnswers();
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

  Future<void> resetBlockTopics() async {
    final result = await _blockListUseCase.resetTopics();
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

  Future<void> resetBlockUsers() async {
    final result = await _blockListUseCase.resetUsers();
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

  Future<void> fetchBlockAnswers() async {
    final result = await _blockListUseCase.fetchAnswers();
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

  Future<void> fetchBlockTopics() async {
    final result = await _blockListUseCase.fetchTopics();
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

  Future<void> fetchBlockUsers() async {
    final result = await _blockListUseCase.fetchUsers();
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

  Future<void> removeBlockAnswer(AnswerViewData answerViewData) async {
    final result = await _blockListUseCase.removeAnswer(
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

  Future<void> removeBlockTopic(TopicViewData topicViewData) async {
    final result = await _blockListUseCase.removeTopic(
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

  Future<void> removeBlockUser(UserViewData userViewData) async {
    final result = await _blockListUseCase.removeUser(
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

  Future<void> disposed() async {
    await blockAnswersSubscription?.cancel();
    await blockTopicsSubscription?.cancel();
    await blockUsersSubscription?.cancel();
    debugPrint('BlockListViewModel disposed');
  }
}
