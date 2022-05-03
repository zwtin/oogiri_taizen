import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/domain/entity/answer.dart';
import 'package:oogiri_taizen/domain/entity/answers.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/repository/answer_repository.dart';
import 'package:oogiri_taizen/domain/repository/block_repository.dart';
import 'package:oogiri_taizen/infra/repository_impl/answer_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/block_repository_impl.dart';

final blockAnswerListUseCaseProvider =
    Provider.autoDispose.family<BlockAnswerListUseCase, UniqueKey>(
  (ref, key) {
    return BlockAnswerListUseCase(
      key,
      ref.watch(answerRepositoryProvider),
      ref.watch(blockRepositoryProvider),
    );
  },
);

class BlockAnswerListUseCase extends ChangeNotifier {
  BlockAnswerListUseCase(
    this._key,
    this._answerRepository,
    this._blockRepository,
  ) {
    _blockAnswerIdsSubscription =
        _blockRepository.getBlockAnswerIdsStream().listen(
      (ids) {
        _blockAnswerIds = ids;
      },
    );
    _blockAnswerIds = _blockRepository.getBlockAnswerIds();
  }

  final AnswerRepository _answerRepository;
  final BlockRepository _blockRepository;

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

      if (answerResult is Success<Answer>) {
        loadedAnswers = loadedAnswers.added(answerResult.value);
      }
    }
    hasNext = _blockAnswerIds.length == loadedAnswers.length;
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
