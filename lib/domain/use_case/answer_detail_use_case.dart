import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/domain/entity/answer.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/entity/topic.dart';
import 'package:oogiri_taizen/domain/entity/user.dart';
import 'package:oogiri_taizen/domain/repository/answer_repository.dart';
import 'package:oogiri_taizen/domain/repository/topic_repository.dart';
import 'package:oogiri_taizen/domain/repository/user_repository.dart';
import 'package:oogiri_taizen/infra/repository_impl/answer_repository_impl.dart';
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
    this._topicRepository,
    this._userRepository,
  );

  final AnswerRepository _answerRepository;
  final TopicRepository _topicRepository;
  final UserRepository _userRepository;

  final UniqueKey _key;
  final String _answerId;
  final _logger = Logger();

  Answer? answer;

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

    answer = _answer;
    notifyListeners();
    return const Result.success(null);
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('AnswerDetailUseCase dispose $_key');
  }
}
