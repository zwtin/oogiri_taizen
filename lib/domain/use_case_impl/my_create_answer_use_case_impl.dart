import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:oogiri_taizen/domain/entity/answer.dart';
import 'package:oogiri_taizen/domain/entity/answers.dart';
import 'package:oogiri_taizen/domain/entity/login_user.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/repository/answer_repository.dart';
import 'package:oogiri_taizen/domain/repository/authentication_repository.dart';
import 'package:oogiri_taizen/domain/repository/favor_repository.dart';
import 'package:oogiri_taizen/domain/repository/like_repository.dart';
import 'package:oogiri_taizen/domain/use_case/my_create_answer_use_case.dart';
import 'package:oogiri_taizen/infra/repository_impl/answer_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/authentication_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/favor_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/like_repository_impl.dart';

final myCreateAnswerUseCaseProvider =
    Provider.autoDispose.family<MyCreateAnswerUseCase, UniqueKey>(
  (ref, key) {
    final myCreateAnswerUseCase = MyCreateAnswerUseCaseImpl(
      key,
      ref.watch(answerRepositoryProvider),
      ref.watch(authenticationRepositoryProvider),
      ref.watch(favorRepositoryProvider),
      ref.watch(likeRepositoryProvider),
    );
    ref.onDispose(myCreateAnswerUseCase.disposed);
    return myCreateAnswerUseCase;
  },
);

class MyCreateAnswerUseCaseImpl implements MyCreateAnswerUseCase {
  MyCreateAnswerUseCaseImpl(
    this._key,
    this._answerRepository,
    this._authenticationRepository,
    this._favorRepository,
    this._likeRepository,
  ) {
    _authenticationRepository.getLoginUserStream().listen(
      (loginUser) {
        _userId = loginUser?.id;
        if (_userId == null) {
          _clearAnswers();
        } else {
          resetAnswers();
        }
      },
    );
    _userId = _authenticationRepository.getLoginUser()?.id;
    if (_userId == null) {
      _clearAnswers();
    } else {
      resetAnswers();
    }
  }

  final UniqueKey _key;

  final AnswerRepository _answerRepository;
  final AuthenticationRepository _authenticationRepository;
  final FavorRepository _favorRepository;
  final LikeRepository _likeRepository;

  bool _isConnecting = false;
  String? _userId;
  Answers _answers = const Answers(list: [], hasNext: true);
  final Map<String, StreamSubscription<bool>> _likeStreamSubscription = {};
  final Map<String, StreamSubscription<bool>> _favorStreamSubscription = {};

  final _controller = StreamController<Answers>();

  void _setAnswers({required Answers answers}) {
    if (!_controller.isClosed) {
      _answers = answers;
      _controller.sink.add(answers);
    }
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

  @override
  Future<Result<void>> fetchAnswers() async {
    if (_userId == null) {
      return Result.failure(OTException());
    }
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
    final createdAnswerIdsResult = await _answerRepository.getCreatedAnswerIds(
      userId: _userId!,
      offset: offset,
      limit: limit + 1,
    );
    if (createdAnswerIdsResult is Failure) {
      return Result.failure(OTException(alertMessage: '投稿したボケが読み込めませんでした'));
    }
    final createdAnswerIds =
        (createdAnswerIdsResult as Success<List<String>>).value;
    final hasNext = createdAnswerIds.length == limit + 1;
    if (hasNext) {
      createdAnswerIds.removeLast();
    }
    final createdAnswers = _answers.list;
    for (final id in createdAnswerIds) {
      final createdAnswerResult = await _answerRepository.getAnswer(id: id);
      if (createdAnswerResult is Failure) {
        continue;
      }
      var createdAnswer = (createdAnswerResult as Success<Answer>).value;

      if (_userId != null) {
        final isLikeResult =
            await _likeRepository.getLike(userId: _userId!, answerId: id);
        final isFavorResult =
            await _favorRepository.getFavor(userId: _userId!, answerId: id);
        if (isLikeResult is Success<bool> && isFavorResult is Success<bool>) {
          createdAnswer = createdAnswer.copyWith(
            isLike: isLikeResult.value,
            isFavor: isFavorResult.value,
          );
        }
      }
      createdAnswers.add(createdAnswer);

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
      answers: _answers.copyWith(list: createdAnswers, hasNext: hasNext),
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
    debugPrint('UserCreateAnswerUseCaseImpl disposed $_key');
  }
}
