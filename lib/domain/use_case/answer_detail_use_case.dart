import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/domain/entity/answer.dart';
import 'package:oogiri_taizen/domain/entity/login_user.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/entity/topic.dart';
import 'package:oogiri_taizen/domain/entity/user.dart';
import 'package:oogiri_taizen/domain/repository/answer_repository.dart';
import 'package:oogiri_taizen/domain/repository/authentication_repository.dart';
import 'package:oogiri_taizen/domain/repository/favor_repository.dart';
import 'package:oogiri_taizen/domain/repository/like_repository.dart';
import 'package:oogiri_taizen/domain/repository/topic_repository.dart';
import 'package:oogiri_taizen/domain/repository/user_repository.dart';
import 'package:oogiri_taizen/infra/repository_impl/answer_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/authentication_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/favor_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/like_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/topic_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/user_repository_impl.dart';
import 'package:tuple/tuple.dart';

final answerDetailUseCaseProvider = ChangeNotifierProvider.autoDispose
    .family<AnswerDetailUseCase, Tuple2<UniqueKey, String>>(
  (ref, tuple) {
    return AnswerDetailUseCase(
      tuple.item1,
      tuple.item2,
      ref.watch(answerRepositoryProvider),
      ref.watch(authenticationRepositoryProvider),
      ref.watch(likeRepositoryProvider),
      ref.watch(favorRepositoryProvider),
      ref.watch(topicRepositoryProvider),
      ref.watch(userRepositoryProvider),
    );
  },
);

class AnswerDetailUseCase extends ChangeNotifier {
  AnswerDetailUseCase(
    this._key,
    this._answerId,
    this._answerRepository,
    this._authenticationRepository,
    this._likeRepository,
    this._favorRepository,
    this._topicRepository,
    this._userRepository,
  ) {
    _loginUserSubscription?.cancel();
    _loginUserSubscription =
        _authenticationRepository.getLoginUserStream().listen(
      (loginUser) async {
        loginUserId = loginUser?.id;
        await resetAnswerDetail();
      },
    );
  }

  final AnswerRepository _answerRepository;
  final AuthenticationRepository _authenticationRepository;
  final LikeRepository _likeRepository;
  final FavorRepository _favorRepository;
  final TopicRepository _topicRepository;
  final UserRepository _userRepository;

  final UniqueKey _key;
  final String _answerId;
  final _logger = Logger();

  String? loginUserId;
  Answer? answer;

  StreamSubscription<LoginUser?>? _loginUserSubscription;
  StreamSubscription<bool>? _isLikeSubscription;
  StreamSubscription<bool>? _isFavorSubscription;

  Future<Result<void>> resetAnswerDetail() async {
    answer = null;
    await _isLikeSubscription?.cancel();
    await _isFavorSubscription?.cancel();
    return fetchAnswerDetail();
  }

  Future<Result<void>> fetchAnswerDetail() async {
    final answerResult = await _answerRepository.getAnswer(id: _answerId);
    if (!(answerResult is Success<Answer>)) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: 'ボケが見つかりませんでした',
        ),
      );
    }
    var _answer = answerResult.value;
    final userResult = await _userRepository.getUser(id: _answer.createdUserId);
    if (!(userResult is Success<User>)) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: 'ボケが見つかりませんでした',
        ),
      );
    }
    _answer = _answer.copyWith(createdUser: userResult.value);
    final topicResult = await _topicRepository.getTopic(id: _answer.topicId);
    if (!(topicResult is Success<Topic>)) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: 'お題が見つかりませんでした',
        ),
      );
    }
    var _topic = topicResult.value;
    final topicUserResult =
        await _userRepository.getUser(id: _topic.createdUserId);
    if (!(topicUserResult is Success<User>)) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: 'ユーザーが見つかりませんでした',
        ),
      );
    }
    _topic = _topic.copyWith(createdUser: topicUserResult.value);
    _answer = _answer.copyWith(topic: _topic);

    if (loginUserId != null) {
      final isLikeResult = await _likeRepository.getLike(
        userId: loginUserId!,
        answerId: _answer.id,
      );
      final isFavorResult = await _favorRepository.getFavor(
        userId: loginUserId!,
        answerId: _answer.id,
      );
      if (isLikeResult is Success<bool> && isFavorResult is Success<bool>) {
        _answer = _answer.copyWith(
          isLike: isLikeResult.value,
          isFavor: isFavorResult.value,
        );
      }

      _isLikeSubscription = _likeRepository
          .getLikeStream(userId: loginUserId!, answerId: _answer.id)
          .listen((value) {
        if (answer == null) {
          return;
        }
        if (value && !answer!.isLike) {
          answer = answer!.copyWith(
            isLike: value,
            likedCount: answer!.likedCount + 1,
          );
          notifyListeners();
        } else if (!value && answer!.isLike) {
          answer = answer!.copyWith(
            isLike: value,
            likedCount: answer!.likedCount - 1,
          );
          notifyListeners();
        }
      });

      _isFavorSubscription = _favorRepository
          .getFavorStream(userId: loginUserId!, answerId: _answer.id)
          .listen((value) {
        if (answer == null) {
          return;
        }
        if (value && !answer!.isFavor) {
          answer = answer!.copyWith(
            isFavor: value,
            favoredCount: answer!.favoredCount + 1,
          );
          notifyListeners();
        } else if (!value && answer!.isFavor) {
          answer = answer!.copyWith(
            isFavor: value,
            favoredCount: answer!.favoredCount - 1,
          );
          notifyListeners();
        }
      });
    }

    answer = _answer;
    notifyListeners();
    return const Result.success(null);
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('AnswerDetailUseCase dispose $_key');

    _loginUserSubscription?.cancel();
    _isLikeSubscription?.cancel();
    _isFavorSubscription?.cancel();
  }
}
