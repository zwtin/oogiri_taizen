import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/domain/entity/answers.dart';
import 'package:oogiri_taizen/domain/entity/login_user.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/repository/answer_repository.dart';
import 'package:oogiri_taizen/domain/repository/authentication_repository.dart';
import 'package:oogiri_taizen/domain/repository/block_repository.dart';
import 'package:oogiri_taizen/domain/repository/favor_repository.dart';
import 'package:oogiri_taizen/domain/repository/like_repository.dart';
import 'package:oogiri_taizen/infra/repository_impl/answer_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/authentication_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/block_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/favor_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/like_repository_impl.dart';

final newAnswerListUseCaseProvider =
    Provider.autoDispose.family<NewAnswerListUseCase, UniqueKey>(
  (ref, key) {
    return NewAnswerListUseCase(
      key,
      ref.watch(answerRepositoryProvider),
      ref.watch(authenticationRepositoryProvider),
      ref.watch(blockRepositoryProvider),
      ref.watch(favorRepositoryProvider),
      ref.watch(likeRepositoryProvider),
    );
  },
);

class NewAnswerListUseCase extends ChangeNotifier {
  NewAnswerListUseCase(
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
        resetAnswers();
      },
    );
    _blockAnswerIds = _blockRepository.getBlockAnswerIds();

    _blockTopicIdsSubscription?.cancel();
    _blockTopicIdsSubscription =
        _blockRepository.getBlockTopicIdsStream().listen(
      (ids) {
        _blockTopicIds = ids;
        resetAnswers();
      },
    );
    _blockTopicIds = _blockRepository.getBlockTopicIds();

    _blockUserIdsSubscription?.cancel();
    _blockUserIdsSubscription = _blockRepository.getBlockUserIdsStream().listen(
      (ids) {
        _blockUserIds = ids;
        resetAnswers();
      },
    );
    _blockUserIds = _blockRepository.getBlockUserIds();

    _authenticationRepository.getLoginUserStream().listen(
      (_loginUser) {
        loginUser = _loginUser;
        resetAnswers();
      },
    );

    loginUser = _authenticationRepository.getLoginUser();
    resetAnswers();
  }

  final AnswerRepository _answerRepository;
  final AuthenticationRepository _authenticationRepository;
  final BlockRepository _blockRepository;
  final FavorRepository _favorRepository;
  final LikeRepository _likeRepository;

  final UniqueKey _key;
  final _logger = Logger();

  LoginUser? loginUser;
  bool isConnecting = false;
  Answers answers = const Answers(list: []);
  bool hasNext = true;

  List<String> _blockAnswerIds = [];
  StreamSubscription<List<String>>? _blockAnswerIdsSubscription;
  List<String> _blockTopicIds = [];
  StreamSubscription<List<String>>? _blockTopicIdsSubscription;
  List<String> _blockUserIds = [];
  StreamSubscription<List<String>>? _blockUserIdsSubscription;
  final Map<String, StreamSubscription<bool>> _isLikeSubscriptions = {};
  final Map<String, StreamSubscription<bool>> _isFavorSubscriptions = {};

  Future<Result<void>> resetAnswers() async {
    final clearAnswersResult = await _clearAnswers();
    if (clearAnswersResult is Failure) {
      return clearAnswersResult;
    }
    return fetchAnswers();
  }

  Future<Result<void>> _clearAnswers() async {
    for (final element in _isLikeSubscriptions.values) {
      try {
        await element.cancel();
      } on Exception catch (_) {
        return Result.failure(
          OTException(
            title: 'エラー',
            text: 'ボケを消すことに失敗しました',
          ),
        );
      }
    }
    for (final element in _isFavorSubscriptions.values) {
      try {
        await element.cancel();
      } on Exception catch (_) {
        return Result.failure(
          OTException(
            title: 'エラー',
            text: 'ボケを消すことに失敗しました',
          ),
        );
      }
    }
    _isLikeSubscriptions.clear();
    _isFavorSubscriptions.clear();

    answers = const Answers(list: []);
    hasNext = true;

    notifyListeners();
    return const Result.success(null);
  }

  Future<Result<void>> fetchAnswers() async {
    if (!hasNext) {
      return const Result.success(null);
    }
    if (isConnecting) {
      return const Result.success(null);
    }
    final offset = answers.lastOrNull?.createdAt;
    const limit = 10;
    isConnecting = true;
    notifyListeners();
    final newAnswerIdsResult = await _answerRepository.getNewAnswerIds(
      offset: offset,
      limit: limit + 1,
    );
    if (newAnswerIdsResult is Failure) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: '新着ボケを読み込めませんでした',
        ),
      );
    }
    final newAnswerIds = (newAnswerIdsResult as Success<List<String>>).value;
    hasNext = newAnswerIds.length == limit + 1;
    if (hasNext) {
      newAnswerIds.removeLast();
    }
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
    return const Result.success(null);
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('NewAnswerListUseCase dispose $_key');

    for (final element in _isLikeSubscriptions.values) {
      element.cancel();
    }
    for (final element in _isFavorSubscriptions.values) {
      element.cancel();
    }
    _blockAnswerIdsSubscription?.cancel();
    _blockTopicIdsSubscription?.cancel();
    _blockUserIdsSubscription?.cancel();
  }
}
