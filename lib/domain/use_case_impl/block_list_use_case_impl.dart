import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:oogiri_taizen/domain/entity/answer.dart';
import 'package:oogiri_taizen/domain/entity/answers.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/entity/topic.dart';
import 'package:oogiri_taizen/domain/entity/topics.dart';
import 'package:oogiri_taizen/domain/entity/user.dart';
import 'package:oogiri_taizen/domain/entity/users.dart';
import 'package:oogiri_taizen/domain/repository/answer_repository.dart';
import 'package:oogiri_taizen/domain/repository/block_repository.dart';
import 'package:oogiri_taizen/domain/repository/topic_repository.dart';
import 'package:oogiri_taizen/domain/repository/user_repository.dart';
import 'package:oogiri_taizen/domain/use_case/block_list_use_case.dart';
import 'package:oogiri_taizen/infra/repository_impl/answer_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/block_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/topic_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/user_repository_impl.dart';

final blockListUseCaseProvider =
    Provider.autoDispose.family<BlockListUseCase, UniqueKey>(
  (ref, key) {
    final blockListUseCase = BlockListUseCaseImpl(
      key,
      ref.watch(answerRepositoryProvider),
      ref.watch(blockRepositoryProvider),
      ref.watch(topicRepositoryProvider),
      ref.watch(userRepositoryProvider),
    );
    ref.onDispose(blockListUseCase.disposed);
    return blockListUseCase;
  },
);

class BlockListUseCaseImpl implements BlockListUseCase {
  BlockListUseCaseImpl(
    this._key,
    this._answerRepository,
    this._blockRepository,
    this._topicRepository,
    this._userRepository,
  ) {
    // ブロックIDsは変化するたびにスクロールの一番上に戻るのはかなり使いづらくなるため、
    // IDsを監視することはしない
    _blockAnswerIds = _blockRepository.getBlockAnswerIds();
    _blockTopicIds = _blockRepository.getBlockTopicIds();
    _blockUserIds = _blockRepository.getBlockUserIds();
  }

  final UniqueKey _key;
  final AnswerRepository _answerRepository;
  final BlockRepository _blockRepository;
  final TopicRepository _topicRepository;
  final UserRepository _userRepository;

  List<String> _blockAnswerIds = [];
  List<String> _blockTopicIds = [];
  List<String> _blockUserIds = [];

  bool _isConnectingAnswer = false;
  bool _isConnectingTopic = false;
  bool _isConnectingUser = false;

  Answers _answers = const Answers(list: [], hasNext: true);
  Topics _topics = const Topics(list: [], hasNext: true);
  Users _users = const Users(list: [], hasNext: true);

  final _answerController = StreamController<Answers>();
  final _topicController = StreamController<Topics>();
  final _userController = StreamController<Users>();

  void _setAnswers({required Answers answers}) {
    _answers = answers;
    _answerController.sink.add(answers);
  }

  void _setTopics({required Topics topics}) {
    _topics = topics;
    _topicController.sink.add(topics);
  }

  void _setUsers({required Users users}) {
    _users = users;
    _userController.sink.add(users);
  }

  @override
  Stream<Answers> getAnswersStream() {
    return _answerController.stream;
  }

  @override
  Stream<Topics> getTopicsStream() {
    return _topicController.stream;
  }

  @override
  Stream<Users> getUsersStream() {
    return _userController.stream;
  }

  @override
  Future<Result<void>> resetAnswers() async {
    _clearAnswers();
    _blockAnswerIds = _blockRepository.getBlockAnswerIds();

    final result = await fetchAnswers();
    if (result is Failure<OTException>) {
      return result;
    } else if (result is Failure) {
      return Result.failure(OTException(alertMessage: '通信エラーが発生しました'));
    }

    return const Result.success(null);
  }

  @override
  Future<Result<void>> resetTopics() async {
    _clearTopics();
    _blockTopicIds = _blockRepository.getBlockTopicIds();

    final result = await fetchTopics();
    if (result is Failure<OTException>) {
      return result;
    } else if (result is Failure) {
      return Result.failure(OTException(alertMessage: '通信エラーが発生しました'));
    }

    return const Result.success(null);
  }

  @override
  Future<Result<void>> resetUsers() async {
    _clearUsers();
    _blockUserIds = _blockRepository.getBlockUserIds();

    final result = await fetchUsers();
    if (result is Failure<OTException>) {
      return result;
    } else if (result is Failure) {
      return Result.failure(OTException(alertMessage: '通信エラーが発生しました'));
    }

    return const Result.success(null);
  }

  void _clearAnswers() {
    _setAnswers(
      answers: _answers.copyWith(list: [], hasNext: true),
    );
  }

  void _clearTopics() {
    _setTopics(
      topics: _topics.copyWith(list: [], hasNext: true),
    );
  }

  void _clearUsers() {
    _setUsers(
      users: _users.copyWith(list: [], hasNext: true),
    );
  }

  @override
  Future<Result<void>> fetchAnswers() async {
    if (!_answers.hasNext) {
      return Result.failure(OTException());
    }
    if (_isConnectingAnswer) {
      return Result.failure(OTException());
    }
    const limit = 10;
    _isConnectingAnswer = true;

    final newAnswers = _answers.list;
    final int startIndex;
    if (_answers.list.isNotEmpty) {
      final lastAnswer = _answers.list.last;
      startIndex = _blockAnswerIds.indexWhere(
            (id) {
              return id == lastAnswer.id;
            },
          ) +
          1;
    } else {
      startIndex = 0;
    }
    for (var index = startIndex; index < (startIndex + limit); index++) {
      if (index >= _blockAnswerIds.length) {
        break;
      }
      final id = _blockAnswerIds.elementAt(index);
      final newAnswerResult = await _answerRepository.getAnswer(id: id);
      if (newAnswerResult is Failure) {
        continue;
      }
      final newAnswer = (newAnswerResult as Success<Answer>).value;

      newAnswers.add(newAnswer);
    }
    _isConnectingAnswer = false;
    _setAnswers(
      answers: _answers.copyWith(
        list: newAnswers,
        hasNext:
            newAnswers.isNotEmpty && newAnswers.last.id != _blockAnswerIds.last,
      ),
    );
    return const Result.success(null);
  }

  @override
  Future<Result<void>> fetchTopics() async {
    if (!_topics.hasNext) {
      return Result.failure(OTException());
    }
    if (_isConnectingTopic) {
      return Result.failure(OTException());
    }
    const limit = 10;
    _isConnectingTopic = true;

    final newTopics = _topics.list;
    final int startIndex;
    if (_topics.list.isNotEmpty) {
      final lastTopic = _topics.list.last;
      startIndex = _blockTopicIds.indexWhere(
            (id) {
              return id == lastTopic.id;
            },
          ) +
          1;
    } else {
      startIndex = 0;
    }
    for (var index = startIndex; index < (startIndex + limit); index++) {
      if (index >= _blockTopicIds.length) {
        break;
      }
      final id = _blockTopicIds.elementAt(index);
      final newTopicResult = await _topicRepository.getTopic(id: id);
      if (newTopicResult is Failure) {
        continue;
      }
      final newTopic = (newTopicResult as Success<Topic>).value;

      newTopics.add(newTopic);
    }
    _isConnectingTopic = false;
    _setTopics(
      topics: _topics.copyWith(
        list: newTopics,
        hasNext:
            newTopics.isNotEmpty && newTopics.last.id != _blockTopicIds.last,
      ),
    );
    return const Result.success(null);
  }

  @override
  Future<Result<void>> fetchUsers() async {
    if (!_users.hasNext) {
      return Result.failure(OTException());
    }
    if (_isConnectingUser) {
      return Result.failure(OTException());
    }
    const limit = 10;
    _isConnectingUser = true;

    final newUsers = _users.list;
    final int startIndex;
    if (_users.list.isNotEmpty) {
      final lastUser = _users.list.last;
      startIndex = _blockUserIds.indexWhere(
            (id) {
              return id == lastUser.id;
            },
          ) +
          1;
    } else {
      startIndex = 0;
    }
    for (var index = startIndex; index < (startIndex + limit); index++) {
      if (index >= _blockUserIds.length) {
        break;
      }
      final id = _blockUserIds.elementAt(index);
      final newUserResult = await _userRepository.getUser(id: id);
      if (newUserResult is Failure) {
        continue;
      }
      final newUser = (newUserResult as Success<User>).value;

      newUsers.add(newUser);
    }
    _isConnectingUser = false;
    _setUsers(
      users: _users.copyWith(
        list: newUsers,
        hasNext: newUsers.isNotEmpty && newUsers.last.id != _blockUserIds.last,
      ),
    );
    return const Result.success(null);
  }

  @override
  Future<Result<void>> removeAnswer({required Answer answer}) async {
    final removeResult =
        await _blockRepository.removeBlockAnswerId(answerId: answer.id);
    if (removeResult is Failure) {
      return Result.failure(OTException(alertMessage: 'ブロック解除に失敗しました'));
    }
    final removedAnswers =
        _answers.list.skipWhile((value) => value.id == answer.id).toList();
    _setAnswers(answers: _answers.copyWith(list: removedAnswers));
    return const Result.success(null);
  }

  @override
  Future<Result<void>> removeTopic({required Topic topic}) async {
    final removeResult =
        await _blockRepository.removeBlockTopicId(topicId: topic.id);
    if (removeResult is Failure) {
      return Result.failure(OTException(alertMessage: 'ブロック解除に失敗しました'));
    }
    final removedTopics =
        _topics.list.skipWhile((value) => value.id == topic.id).toList();
    _setTopics(topics: _topics.copyWith(list: removedTopics));
    return const Result.success(null);
  }

  @override
  Future<Result<void>> removeUser({required User user}) async {
    final removeResult =
        await _blockRepository.removeBlockUserId(userId: user.id);
    if (removeResult is Failure) {
      return Result.failure(OTException(alertMessage: 'ブロック解除に失敗しました'));
    }
    final removedUsers =
        _users.list.skipWhile((value) => value.id == user.id).toList();
    _setUsers(users: _users.copyWith(list: removedUsers));
    return const Result.success(null);
  }

  Future<void> disposed() async {
    await _answerController.close();
    await _topicController.close();
    await _userController.close();
    debugPrint('BlockListUseCaseImpl disposed $_key');
  }
}
