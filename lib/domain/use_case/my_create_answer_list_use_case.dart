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
import 'package:oogiri_taizen/domain/repository/topic_repository.dart';
import 'package:oogiri_taizen/domain/repository/user_repository.dart';
import 'package:oogiri_taizen/infra/repository_impl/answer_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/authentication_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/topic_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/user_repository_impl.dart';

final myCreateAnswerListUseCaseProvider = ChangeNotifierProvider.autoDispose
    .family<MyCreateAnswerListUseCase, UniqueKey>(
  (ref, key) {
    return MyCreateAnswerListUseCase(
      key,
      ref.watch(answerRepositoryProvider),
      ref.watch(authenticationRepositoryProvider),
      ref.watch(topicRepositoryProvider),
      ref.watch(userRepositoryProvider),
    );
  },
);

class MyCreateAnswerListUseCase extends ChangeNotifier {
  MyCreateAnswerListUseCase(
    this._key,
    this._answerRepository,
    this._authenticationRepository,
    this._topicRepository,
    this._userRepository,
  ) {
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
  final TopicRepository _topicRepository;
  final UserRepository _userRepository;

  final UniqueKey _key;
  final _logger = Logger();

  String? loginUserId;
  bool hasNext = true;
  Answers get showingAnswers {
    return _loadedAnswers;
  }

  bool _isConnecting = false;
  Answers _loadedAnswers = const Answers(list: []);

  StreamSubscription<LoginUser?>? _loginUserSubscription;

  Future<Result<void>> resetAnswers() async {
    final clearAnswersResult = await _clearAnswers();
    if (clearAnswersResult is Failure) {
      return clearAnswersResult;
    }
    return fetchAnswers();
  }

  Future<Result<void>> _clearAnswers() async {
    _loadedAnswers = const Answers(list: []);
    hasNext = true;

    notifyListeners();
    return const Result.success(null);
  }

  Future<Result<void>> fetchAnswers() async {
    if (loginUserId == null) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: 'ログインしてください',
        ),
      );
    }
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

    final createdAnswersResult = await _answerRepository.getCreatedAnswers(
      userId: loginUserId!,
      offset: offset,
      limit: limit + 1,
    );
    if (createdAnswersResult is Failure) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: '新着ボケを読み込めませんでした',
        ),
      );
    }
    var createdAnswers = (createdAnswersResult as Success<Answers>).value;
    hasNext = createdAnswers.length == limit + 1;
    if (hasNext) {
      createdAnswers = createdAnswers.removedLast();
    }
    for (var i = 0; i < createdAnswers.length; i++) {
      var answer = createdAnswers.getByIndex(i)!;
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

      _loadedAnswers = _loadedAnswers.added(answer);
    }

    _isConnecting = false;
    notifyListeners();
    return const Result.success(null);
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('MyCreateAnswerListUseCase dispose $_key');

    _loginUserSubscription?.cancel();
  }
}
