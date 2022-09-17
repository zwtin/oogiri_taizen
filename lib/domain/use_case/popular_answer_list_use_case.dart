import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/domain/entity/answers.dart';
import 'package:oogiri_taizen/domain/entity/login_user.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/entity/topic.dart';
import 'package:oogiri_taizen/domain/entity/user.dart';
import 'package:oogiri_taizen/domain/repository/answer_repository.dart';
import 'package:oogiri_taizen/domain/repository/authentication_repository.dart';
import 'package:oogiri_taizen/domain/repository/block_repository.dart';
import 'package:oogiri_taizen/domain/repository/favor_repository.dart';
import 'package:oogiri_taizen/domain/repository/like_repository.dart';
import 'package:oogiri_taizen/domain/repository/topic_repository.dart';
import 'package:oogiri_taizen/domain/repository/user_repository.dart';
import 'package:oogiri_taizen/infra/repository_impl/answer_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/authentication_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/block_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/favor_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/like_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/topic_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/user_repository_impl.dart';

final popularAnswerListUseCaseProvider = ChangeNotifierProvider.autoDispose
    .family<PopularAnswerListUseCase, UniqueKey>(
  (ref, key) {
    return PopularAnswerListUseCase(
      key,
      ref.watch(answerRepositoryProvider),
      ref.watch(authenticationRepositoryProvider),
      ref.watch(blockRepositoryProvider),
      ref.watch(favorRepositoryProvider),
      ref.watch(likeRepositoryProvider),
      ref.watch(topicRepositoryProvider),
      ref.watch(userRepositoryProvider),
    );
  },
);

class PopularAnswerListUseCase extends ChangeNotifier {
  PopularAnswerListUseCase(
    this._key,
    this._answerRepository,
    this._authenticationRepository,
    this._blockRepository,
    this._favorRepository,
    this._likeRepository,
    this._topicRepository,
    this._userRepository,
  ) {
    _blockAnswerIdsSubscription?.cancel();
    _blockAnswerIdsSubscription =
        _blockRepository.getBlockAnswerIdsStream().listen(
      (ids) async {
        _blockAnswerIds = ids;
        await resetAnswers();
      },
    );

    _blockTopicIdsSubscription?.cancel();
    _blockTopicIdsSubscription =
        _blockRepository.getBlockTopicIdsStream().listen(
      (ids) async {
        _blockTopicIds = ids;
        await resetAnswers();
      },
    );

    _blockUserIdsSubscription?.cancel();
    _blockUserIdsSubscription = _blockRepository.getBlockUserIdsStream().listen(
      (ids) async {
        _blockUserIds = ids;
        await resetAnswers();
      },
    );

    _loginUserSubscription?.cancel();
    _loginUserSubscription =
        _authenticationRepository.getLoginUserStream().listen(
      (loginUser) async {
        loginUserId = loginUser?.id;
        await resetAnswers();
      },
    );
  }

  final AnswerRepository _answerRepository;
  final AuthenticationRepository _authenticationRepository;
  final BlockRepository _blockRepository;
  final FavorRepository _favorRepository;
  final LikeRepository _likeRepository;
  final TopicRepository _topicRepository;
  final UserRepository _userRepository;

  final UniqueKey _key;
  final _logger = Logger();

  String? loginUserId;
  bool hasNext = true;
  Answers get showingAnswers {
    return _loadedAnswers.filteredBlock(
      blockAnswerIds: _blockAnswerIds,
      blockTopicIds: _blockTopicIds,
      blockUserIds: _blockUserIds,
    );
  }

  bool _isConnecting = false;
  Answers _loadedAnswers = const Answers(list: []);

  StreamSubscription<LoginUser?>? _loginUserSubscription;
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

    _loadedAnswers = const Answers(list: []);
    hasNext = true;

    notifyListeners();
    return const Result.success(null);
  }

  Future<Result<void>> fetchAnswers() async {
    if (!hasNext) {
      return const Result.success(null);
    }
    if (_isConnecting) {
      return const Result.success(null);
    }
    _isConnecting = true;
    notifyListeners();

    final offset = _loadedAnswers.lastOrNull?.createdAt;
    const limit = 10;

    final newAnswersResult = await _answerRepository.getNewAnswers(
      offset: offset,
      limit: limit + 1,
    );
    if (newAnswersResult is Failure) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: '新着ボケを読み込めませんでした',
        ),
      );
    }
    var newAnswers = (newAnswersResult as Success<Answers>).value;
    hasNext = newAnswers.length == limit + 1;
    if (hasNext) {
      newAnswers = newAnswers.removedLast();
    }
    for (var i = 0; i < newAnswers.length; i++) {
      var answer = newAnswers.getByIndex(i)!;
      final createdUserResult =
          await _userRepository.getUser(id: answer.createdUserId);
      if (!(createdUserResult is Success<User>)) {
        continue;
      }
      answer = answer.copyWith(createdUser: createdUserResult.value);
      final topicResult = await _topicRepository.getTopic(id: answer.topicId);
      if (!(topicResult is Success<Topic>)) {
        continue;
      }
      var topic = topicResult.value;
      final topicCreatedUserResult =
          await _userRepository.getUser(id: topic.createdUserId);
      if (!(topicCreatedUserResult is Success<User>)) {
        continue;
      }
      topic = topic.copyWith(createdUser: topicCreatedUserResult.value);
      answer = answer.copyWith(topic: topic);

      if (loginUserId != null) {
        final isLikeResult = await _likeRepository.getLike(
          userId: loginUserId!,
          answerId: answer.id,
        );
        final isFavorResult = await _favorRepository.getFavor(
          userId: loginUserId!,
          answerId: answer.id,
        );
        if (isLikeResult is Success<bool> && isFavorResult is Success<bool>) {
          answer = answer.copyWith(
            isLike: isLikeResult.value,
            isFavor: isFavorResult.value,
          );
        }
      }

      _loadedAnswers = _loadedAnswers.added(answer);

      if (loginUserId != null) {
        _isLikeSubscriptions[answer.id] = _likeRepository
            .getLikeStream(userId: loginUserId!, answerId: answer.id)
            .listen((value) {
          var newAnswer = _loadedAnswers.getById(answer.id);
          if (newAnswer == null) {
            return;
          }
          if (value && !newAnswer.isLike) {
            newAnswer = newAnswer.copyWith(
              isLike: value,
              likedCount: newAnswer.likedCount + 1,
            );
            _loadedAnswers = _loadedAnswers.update(newAnswer);
            notifyListeners();
          } else if (!value && newAnswer.isLike) {
            newAnswer = newAnswer.copyWith(
              isLike: value,
              likedCount: newAnswer.likedCount - 1,
            );
            _loadedAnswers = _loadedAnswers.update(newAnswer);
            notifyListeners();
          }
        });

        _isFavorSubscriptions[answer.id] = _favorRepository
            .getFavorStream(userId: loginUserId!, answerId: answer.id)
            .listen((value) {
          var newAnswer = _loadedAnswers.getById(answer.id);
          if (newAnswer == null) {
            return;
          }
          if (value && !newAnswer.isFavor) {
            newAnswer = newAnswer.copyWith(
              isFavor: value,
              favoredCount: newAnswer.favoredCount + 1,
            );
            _loadedAnswers = _loadedAnswers.update(newAnswer);
            notifyListeners();
          } else if (!value && newAnswer.isFavor) {
            newAnswer = newAnswer.copyWith(
              isFavor: value,
              favoredCount: newAnswer.favoredCount - 1,
            );
            _loadedAnswers = _loadedAnswers.update(newAnswer);
            notifyListeners();
          }
        });
      }
    }

    _isConnecting = false;
    notifyListeners();
    return const Result.success(null);
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('PopularAnswerListUseCase dispose $_key');

    for (final element in _isLikeSubscriptions.values) {
      element.cancel();
    }
    for (final element in _isFavorSubscriptions.values) {
      element.cancel();
    }
    _loginUserSubscription?.cancel();
    _blockAnswerIdsSubscription?.cancel();
    _blockTopicIdsSubscription?.cancel();
    _blockUserIdsSubscription?.cancel();
  }
}
