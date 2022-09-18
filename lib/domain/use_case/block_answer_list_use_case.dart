import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/domain/entity/answer.dart';
import 'package:oogiri_taizen/domain/entity/answers.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/entity/topic.dart';
import 'package:oogiri_taizen/domain/entity/user.dart';
import 'package:oogiri_taizen/domain/repository/answer_repository.dart';
import 'package:oogiri_taizen/domain/repository/block_repository.dart';
import 'package:oogiri_taizen/domain/repository/topic_repository.dart';
import 'package:oogiri_taizen/domain/repository/user_repository.dart';
import 'package:oogiri_taizen/infra/repository_impl/answer_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/block_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/topic_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/user_repository_impl.dart';

final blockAnswerListUseCaseProvider = ChangeNotifierProvider.autoDispose
    .family<BlockAnswerListUseCase, UniqueKey>(
  (ref, key) {
    return BlockAnswerListUseCase(
      key,
      ref.watch(answerRepositoryProvider),
      ref.watch(blockRepositoryProvider),
      ref.watch(topicRepositoryProvider),
      ref.watch(userRepositoryProvider),
    );
  },
);

class BlockAnswerListUseCase extends ChangeNotifier {
  BlockAnswerListUseCase(
    this._key,
    this._answerRepository,
    this._blockRepository,
    this._topicRepository,
    this._userRepository,
  ) {
    _blockAnswerIdsSubscription =
        _blockRepository.getBlockAnswerIdsStream().listen(
      (ids) {
        _blockAnswerIds = ids;
        resetBlockAnswers();
      },
    );
  }

  final AnswerRepository _answerRepository;
  final BlockRepository _blockRepository;
  final TopicRepository _topicRepository;
  final UserRepository _userRepository;

  final UniqueKey _key;
  final _logger = Logger();

  bool hasNext = true;
  bool _isConnecting = false;
  Answers loadedAnswers = const Answers(list: []);

  List<String> _blockAnswerIds = [];
  StreamSubscription<List<String>>? _blockAnswerIdsSubscription;

  Future<Result<void>> resetBlockAnswers() async {
    final clearLoadedAnswersResult = await _clearLoadedAnswers();
    if (clearLoadedAnswersResult is Failure) {
      return clearLoadedAnswersResult;
    }
    return fetchBlockAnswers();
  }

  Future<Result<void>> _clearLoadedAnswers() async {
    loadedAnswers = const Answers(list: []);
    hasNext = true;

    notifyListeners();
    return const Result.success(null);
  }

  Future<Result<void>> fetchBlockAnswers() async {
    if (_isConnecting) {
      return const Result.success(null);
    }
    _isConnecting = true;
    notifyListeners();
    var willLoadAnswerIds = <String>[];
    if (loadedAnswers.isEmpty) {
      willLoadAnswerIds = _blockAnswerIds.take(10).toList();
    } else {
      willLoadAnswerIds = _blockAnswerIds
          .skipWhile((value) => value != loadedAnswers.lastOrNull?.id)
          .take(10)
          .toList();
    }
    for (final blockAnswerId in willLoadAnswerIds) {
      final answerResult = await _answerRepository.getAnswer(id: blockAnswerId);
      if (answerResult is Failure) {
        continue;
      }
      var answer = (answerResult as Success<Answer>).value;
      final createdUserResult =
          await _userRepository.getUser(id: answer.createdUserId);
      if (createdUserResult is Failure) {
        continue;
      }
      final createdUser = (createdUserResult as Success<User>).value;
      final topicResult = await _topicRepository.getTopic(id: answer.topicId);
      if (topicResult is Failure) {
        continue;
      }
      var topic = (topicResult as Success<Topic>).value;
      final topicCreatedUserResult =
          await _userRepository.getUser(id: topic.createdUserId);
      if (topicCreatedUserResult is Failure) {
        continue;
      }
      final topicCreatedUser = (topicCreatedUserResult as Success<User>).value;
      topic = topic.copyWith(createdUser: topicCreatedUser);

      answer = answer.copyWith(
        createdUser: createdUser,
        topic: topic,
      );

      loadedAnswers = loadedAnswers.added(answer);
    }
    hasNext = _blockAnswerIds.length != loadedAnswers.length;
    _isConnecting = false;
    notifyListeners();
    return const Result.success(null);
  }

  Future<Result<void>> removeBlockAnswer({required Answer answer}) async {
    final result =
        await _blockRepository.removeBlockAnswerId(answerId: answer.id);
    if (result is Failure) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: 'ブロックボケの解除に失敗しました',
        ),
      );
    }
    loadedAnswers = loadedAnswers.removed(answer);
    notifyListeners();
    return const Result.success(null);
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('BlockAnswerListUseCase dispose $_key');

    _blockAnswerIdsSubscription?.cancel();
  }
}
