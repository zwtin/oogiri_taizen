import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiri_taizen/domain/entity/answer.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/repository/answer_repository.dart';
import 'package:oogiri_taizen/domain/repository/authentication_repository.dart';
import 'package:oogiri_taizen/domain/repository/favor_repository.dart';
import 'package:oogiri_taizen/domain/repository/like_repository.dart';
import 'package:oogiri_taizen/domain/use_case/answer_use_case.dart';
import 'package:oogiri_taizen/infra/repository_impl/answer_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/authentication_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/favor_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/like_repository_impl.dart';
import 'package:tuple/tuple.dart';

final answerUseCaseProvider =
    Provider.autoDispose.family<AnswerUseCase, Tuple2<UniqueKey, String>>(
  (ref, tuple) {
    final answerUseCase = AnswerUseCaseImpl(
      tuple.item1,
      tuple.item2,
      ref.watch(answerRepositoryProvider),
      ref.watch(authenticationRepositoryProvider),
      ref.watch(favorRepositoryProvider),
      ref.watch(likeRepositoryProvider),
    );
    ref.onDispose(answerUseCase.disposed);
    return answerUseCase;
  },
);

class AnswerUseCaseImpl implements AnswerUseCase, ChangeNotifier {
  AnswerUseCaseImpl(
    this._key,
    this._id,
    this._answerRepository,
    this._authenticationRepository,
    this._favorRepository,
    this._likeRepository,
  ) {
    _authenticationRepository.getLoginUserStream().listen(
      (loginUser) {
        _userId = loginUser?.id;
        resetAnswer();
      },
    );
    _userId = _authenticationRepository.getLoginUser()?.id;
    resetAnswer();
  }

  final UniqueKey _key;
  final String _id;

  final AnswerRepository _answerRepository;
  final AuthenticationRepository _authenticationRepository;
  final FavorRepository _favorRepository;
  final LikeRepository _likeRepository;

  bool _isConnecting = false;
  String? _userId;
  Answer? _answer;

  final _controller = StreamController<Answer?>();
  StreamSubscription<bool>? likeStreamSubscription;
  StreamSubscription<bool>? favorStreamSubscription;

  void _setAnswer({required Answer? answer}) {
    if (!_controller.isClosed) {
      _answer = answer;
      _controller.sink.add(answer);
    }
  }

  @override
  Stream<Answer?> getAnswerStream() {
    return _controller.stream;
  }

  @override
  Future<Result<void>> resetAnswer() async {
    await _clearAnswer();
    final result = await fetchAnswer();
    if (result is Failure<OTException>) {
      return result;
    } else if (result is Failure) {
      return Result.failure(OTException(alertMessage: '通信エラーが発生しました'));
    }
    return const Result.success(null);
  }

  Future<void> _clearAnswer() async {
    _setAnswer(
      answer: null,
    );
    await likeStreamSubscription?.cancel();
    await favorStreamSubscription?.cancel();

    likeStreamSubscription = null;
    favorStreamSubscription = null;
  }

  @override
  Future<Result<void>> fetchAnswer() async {
    if (_isConnecting) {
      return Result.failure(OTException());
    }
    _isConnecting = true;
    final result = await _answerRepository.getAnswer(
      id: _id,
    );
    if (result is Failure) {
      return Result.failure(OTException(alertMessage: 'ボケが読み込めませんでした'));
    }
    var answer = (result as Success<Answer>).value;

    if (_userId != null) {
      final isLikeResult =
          await _likeRepository.getLike(userId: _userId!, answerId: answer.id);
      final isFavorResult = await _favorRepository.getFavor(
          userId: _userId!, answerId: answer.id);
      if (isLikeResult is Success<bool> && isFavorResult is Success<bool>) {
        answer = answer.copyWith(
          isLike: isLikeResult.value,
          isFavor: isFavorResult.value,
        );
      }
    }
    _setAnswer(answer: answer);

    if (_userId != null) {
      likeStreamSubscription = _likeRepository
          .getLikeStream(
        userId: _userId!,
        answerId: _answer!.id,
      )
          .listen(
        (value) {
          if (value && !_answer!.isLike) {
            final updatedAnswer = _answer!.copyWith(
              isLike: value,
              likedTime: _answer!.likedTime + 1,
            );
            _setAnswer(answer: updatedAnswer);
          } else if (!value && _answer!.isLike) {
            final updatedAnswer = _answer!.copyWith(
              isLike: value,
              likedTime: _answer!.likedTime - 1,
            );
            _setAnswer(answer: updatedAnswer);
          }
        },
      );
      favorStreamSubscription = _favorRepository
          .getFavorStream(
        userId: _userId!,
        answerId: _answer!.id,
      )
          .listen(
        (value) {
          if (value && !_answer!.isFavor) {
            final updatedAnswer = _answer!.copyWith(
              isFavor: value,
              favoredTime: _answer!.favoredTime + 1,
            );
            _setAnswer(answer: updatedAnswer);
          } else if (!value && _answer!.isFavor) {
            final updatedAnswer = _answer!.copyWith(
              isFavor: value,
              favoredTime: _answer!.favoredTime - 1,
            );
            _setAnswer(answer: updatedAnswer);
          }
        },
      );
    }
    _isConnecting = false;
    return const Result.success(null);
  }

  Future<void> disposed() async {
    await _controller.close();
    await likeStreamSubscription?.cancel();
    await favorStreamSubscription?.cancel();
    debugPrint('NewAnswerUseCaseImpl disposed $_key');
  }
}
