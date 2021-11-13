import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:oogiri_taizen/domain/entity/answer.dart';
import 'package:oogiri_taizen/domain/entity/answers.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/repository/answer_repository.dart';
import 'package:oogiri_taizen/domain/repository/authentication_repository.dart';
import 'package:oogiri_taizen/domain/repository/block_repository.dart';
import 'package:oogiri_taizen/domain/repository/favor_repository.dart';
import 'package:oogiri_taizen/domain/repository/like_repository.dart';
import 'package:oogiri_taizen/domain/use_case/new_answer_use_case.dart';
import 'package:oogiri_taizen/infra/repository_impl/answer_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/authentication_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/block_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/favor_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/like_repository_impl.dart';

final newAnswerUseCaseProvider =
    Provider.autoDispose.family<NewAnswerUseCase, UniqueKey>(
  (ref, key) {
    final newAnswerUseCase = NewAnswerUseCaseImpl(
      key,
      ref.watch(answerRepositoryProvider),
      ref.watch(authenticationRepositoryProvider),
      ref.watch(blockRepositoryProvider),
      ref.watch(favorRepositoryProvider),
      ref.watch(likeRepositoryProvider),
    );
    ref.onDispose(newAnswerUseCase.disposed);
    return newAnswerUseCase;
  },
);

class NewAnswerUseCaseImpl implements NewAnswerUseCase {
  NewAnswerUseCaseImpl(
    this._key,
    this._answerRepository,
    this._authenticationRepository,
    this._blockRepository,
    this._favorRepository,
    this._likeRepository,
  ) {
    _blockAnswerIdsSubscription?.cancel();
    _blockAnswerIdsSubscription =
        _blockRepository.getBlockAnswerIdsStream().listen(
      (ids) {
        _blockAnswerIds = ids;
        _sendAnswers();
      },
    );
    _blockAnswerIds = _blockRepository.getBlockAnswerIds();

    _blockTopicIdsSubscription?.cancel();
    _blockTopicIdsSubscription =
        _blockRepository.getBlockTopicIdsStream().listen(
      (ids) {
        _blockTopicIds = ids;
        _sendAnswers();
      },
    );
    _blockAnswerIds = _blockRepository.getBlockTopicIds();

    _blockUserIdsSubscription?.cancel();
    _blockUserIdsSubscription = _blockRepository.getBlockUserIdsStream().listen(
      (ids) {
        _blockUserIds = ids;
        _sendAnswers();
      },
    );
    _blockAnswerIds = _blockRepository.getBlockUserIds();

    _authenticationRepository.getLoginUserStream().listen(
      (loginUser) {
        _userId = loginUser?.id;
        resetAnswers();
      },
    );
    _userId = _authenticationRepository.getLoginUser()?.id;
    resetAnswers();
  }

  final UniqueKey _key;
  final AnswerRepository _answerRepository;
  final AuthenticationRepository _authenticationRepository;
  final BlockRepository _blockRepository;
  final FavorRepository _favorRepository;
  final LikeRepository _likeRepository;

  List<String> _blockAnswerIds = [];
  StreamSubscription<List<String>>? _blockAnswerIdsSubscription;

  List<String> _blockTopicIds = [];
  StreamSubscription<List<String>>? _blockTopicIdsSubscription;

  List<String> _blockUserIds = [];
  StreamSubscription<List<String>>? _blockUserIdsSubscription;

  bool _isConnecting = false;
  String? _userId;
  Answers _answers = const Answers(list: [], hasNext: true);
  final Map<String, StreamSubscription<bool>> _likeStreamSubscription = {};
  final Map<String, StreamSubscription<bool>> _favorStreamSubscription = {};

  final _controller = StreamController<Answers>();

  void _setAnswers({required Answers answers}) {
    _answers = answers;
    _sendAnswers();
  }

  void _sendAnswers() {
    final filteredList = List<Answer>.from(_answers.list.where((answer) {
      return !(_blockAnswerIds.contains(answer.id) ||
          (_blockTopicIds.contains(answer.topic.id)) ||
          (_blockUserIds.contains(answer.createdUser.id)) ||
          (_blockUserIds.contains(answer.topic.createdUser.id)));
    }));
    final filteredAnswers = Answers(
      list: filteredList,
      hasNext: _answers.hasNext,
    );
    if (!_controller.isClosed) {
      _controller.sink.add(filteredAnswers);
    }
  }

  @override
  Stream<Answers> getAnswersStream() {
    return _controller.stream;
  }

  @override
  Future<Result<void>> resetAnswers() async {
    await _clearAnswers();

    final result = await fetchAnswers();
    if (result is Failure<OTException>) {
      return result;
    } else if (result is Failure) {
      return Result.failure(OTException(alertMessage: '通信エラーが発生しました'));
    }

    return const Result.success(null);
  }

  Future<void> _clearAnswers() async {
    _setAnswers(
      answers: _answers.copyWith(list: [], hasNext: true),
    );
    for (final element in _likeStreamSubscription.values) {
      await element.cancel();
    }
    for (final element in _favorStreamSubscription.values) {
      await element.cancel();
    }
    _likeStreamSubscription.clear();
    _favorStreamSubscription.clear();
  }

  @override
  Future<Result<void>> fetchAnswers() async {
    if (!_answers.hasNext) {
      return Result.failure(OTException());
    }
    if (_isConnecting) {
      return Result.failure(OTException());
    }
    DateTime? offset;
    if (_answers.list.isEmpty) {
      offset = null;
    } else {
      offset = _answers.list.last.createdAt;
    }
    const limit = 10;
    _isConnecting = true;
    final newAnswerIdsResult = await _answerRepository.getNewAnswerIds(
      offset: offset,
      limit: limit + 1,
    );
    if (newAnswerIdsResult is Failure) {
      return Result.failure(OTException(alertMessage: '新着ボケが読み込めませんでした'));
    }
    final newAnswerIds = (newAnswerIdsResult as Success<List<String>>).value;
    final hasNext = newAnswerIds.length == limit + 1;
    if (hasNext) {
      newAnswerIds.removeLast();
    }
    final newAnswers = _answers.list;
    for (final id in newAnswerIds) {
      final newAnswerResult = await _answerRepository.getAnswer(id: id);
      if (newAnswerResult is Failure) {
        continue;
      }
      var newAnswer = (newAnswerResult as Success<Answer>).value;
      if (_userId != null) {
        final isLikeResult =
            await _likeRepository.getLike(userId: _userId!, answerId: id);
        final isFavorResult =
            await _favorRepository.getFavor(userId: _userId!, answerId: id);
        if (isLikeResult is Success<bool> && isFavorResult is Success<bool>) {
          newAnswer = newAnswer.copyWith(
            isLike: isLikeResult.value,
            isFavor: isFavorResult.value,
          );
        }
      }
      newAnswers.add(newAnswer);

      if (_userId != null) {
        _likeStreamSubscription[id] = _likeRepository
            .getLikeStream(
          userId: _userId!,
          answerId: id,
        )
            .listen(
          (value) {
            final list = _answers.list;
            final index = list.indexWhere((element) => element.id == id);
            final answer = list.firstWhere((element) => element.id == id);

            if (value && !answer.isLike) {
              final updatedAnswer = answer.copyWith(
                isLike: value,
                likedTime: answer.likedTime + 1,
              );
              list.replaceRange(index, index + 1, [updatedAnswer]);
              final updatedAnswers = _answers.copyWith(list: list);
              _setAnswers(answers: updatedAnswers);
            } else if (!value && answer.isLike) {
              final updatedAnswer = answer.copyWith(
                isLike: value,
                likedTime: answer.likedTime - 1,
              );
              list.replaceRange(index, index + 1, [updatedAnswer]);
              final updatedAnswers = _answers.copyWith(list: list);
              _setAnswers(answers: updatedAnswers);
            }
          },
        );
        _favorStreamSubscription[id] = _favorRepository
            .getFavorStream(
          userId: _userId!,
          answerId: id,
        )
            .listen(
          (value) {
            final list = _answers.list;
            final index = list.indexWhere((element) => element.id == id);
            final answer = list.firstWhere((element) => element.id == id);

            if (value && !answer.isFavor) {
              final updatedAnswer = answer.copyWith(
                isFavor: value,
                favoredTime: answer.favoredTime + 1,
              );
              list.replaceRange(index, index + 1, [updatedAnswer]);
              final updatedAnswers = _answers.copyWith(list: list);
              _setAnswers(answers: updatedAnswers);
            } else if (!value && answer.isFavor) {
              final updatedAnswer = answer.copyWith(
                isFavor: value,
                favoredTime: answer.favoredTime - 1,
              );
              list.replaceRange(index, index + 1, [updatedAnswer]);
              final updatedAnswers = _answers.copyWith(list: list);
              _setAnswers(answers: updatedAnswers);
            }
          },
        );
      }
    }
    _isConnecting = false;
    _setAnswers(
      answers: _answers.copyWith(list: newAnswers, hasNext: hasNext),
    );
    return const Result.success(null);
  }

  Future<void> disposed() async {
    await _controller.close();
    _likeStreamSubscription.forEach((key, value) async {
      await value.cancel();
    });
    _favorStreamSubscription.forEach((key, value) async {
      await value.cancel();
    });
    await _blockAnswerIdsSubscription?.cancel();
    await _blockTopicIdsSubscription?.cancel();
    await _blockUserIdsSubscription?.cancel();
    debugPrint('NewAnswerUseCaseImpl disposed $_key');
  }
}
