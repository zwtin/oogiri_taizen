import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/entity/topic.dart';
import 'package:oogiri_taizen/domain/entity/topics.dart';
import 'package:oogiri_taizen/domain/entity/user.dart';
import 'package:oogiri_taizen/domain/repository/block_repository.dart';
import 'package:oogiri_taizen/domain/repository/topic_repository.dart';
import 'package:oogiri_taizen/domain/repository/user_repository.dart';
import 'package:oogiri_taizen/infra/repository_impl/block_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/topic_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/user_repository_impl.dart';

final blockTopicListUseCaseProvider =
    ChangeNotifierProvider.autoDispose.family<BlockTopicListUseCase, UniqueKey>(
  (ref, key) {
    return BlockTopicListUseCase(
      key,
      ref.watch(blockRepositoryProvider),
      ref.watch(topicRepositoryProvider),
      ref.watch(userRepositoryProvider),
    );
  },
);

class BlockTopicListUseCase extends ChangeNotifier {
  BlockTopicListUseCase(
    this._key,
    this._blockRepository,
    this._topicRepository,
    this._userRepository,
  ) {
    _blockTopicIdsSubscription =
        _blockRepository.getBlockTopicIdsStream().listen(
      (ids) {
        _blockTopicIds = ids;
        resetBlockTopics();
      },
    );
  }

  final BlockRepository _blockRepository;
  final TopicRepository _topicRepository;
  final UserRepository _userRepository;

  final UniqueKey _key;
  final _logger = Logger();

  bool hasNext = true;
  bool _isConnecting = false;
  Topics loadedTopics = const Topics(list: []);

  List<String> _blockTopicIds = [];
  StreamSubscription<List<String>>? _blockTopicIdsSubscription;

  Future<Result<void>> resetBlockTopics() async {
    final clearLoadedTopicsResult = await _clearLoadedTopics();
    if (clearLoadedTopicsResult is Failure) {
      return clearLoadedTopicsResult;
    }
    return fetchBlockTopics();
  }

  Future<Result<void>> _clearLoadedTopics() async {
    loadedTopics = const Topics(list: []);
    hasNext = true;

    notifyListeners();
    return const Result.success(null);
  }

  Future<Result<void>> fetchBlockTopics() async {
    if (_isConnecting) {
      return const Result.success(null);
    }
    _isConnecting = true;
    notifyListeners();
    var willLoadTopicIds = <String>[];
    if (_blockTopicIds.isEmpty) {
      willLoadTopicIds = _blockTopicIds.take(10).toList();
    } else {
      willLoadTopicIds = _blockTopicIds
          .skipWhile((value) => value != loadedTopics.lastOrNull?.id)
          .take(10)
          .toList();
    }
    for (final blockTopicId in willLoadTopicIds) {
      final topicResult = await _topicRepository.getTopic(id: blockTopicId);
      if (topicResult is Failure) {
        continue;
      }
      var topic = (topicResult as Success<Topic>).value;

      final createdUserResult =
          await _userRepository.getUser(id: topic.createdUserId);
      if (createdUserResult is Failure) {
        continue;
      }
      final createdUser = (createdUserResult as Success<User>).value;
      topic = topic.copyWith(createdUser: createdUser);

      loadedTopics = loadedTopics.added(topic);
    }
    hasNext = _blockTopicIds.isNotEmpty &&
        _blockTopicIds.length != loadedTopics.length;
    _isConnecting = false;
    notifyListeners();
    return const Result.success(null);
  }

  Future<Result<void>> removeBlockTopic({required Topic topic}) async {
    final result = await _blockRepository.removeBlockTopicId(topicId: topic.id);
    if (result is Failure) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: 'ブロックお題の解除に失敗しました',
        ),
      );
    }
    loadedTopics = loadedTopics.removed(topic);
    notifyListeners();
    return const Result.success(null);
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('BlockTopicListUseCase dispose $_key');

    _blockTopicIdsSubscription?.cancel();
  }
}
