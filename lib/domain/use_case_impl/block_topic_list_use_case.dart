import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/entity/topic.dart';
import 'package:oogiri_taizen/domain/entity/topics.dart';
import 'package:oogiri_taizen/domain/repository/block_repository.dart';
import 'package:oogiri_taizen/domain/repository/topic_repository.dart';
import 'package:oogiri_taizen/infra/repository_impl/block_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/topic_repository_impl.dart';

final blockTopicListUseCaseProvider =
    Provider.autoDispose.family<BlockTopicListUseCase, UniqueKey>(
  (ref, key) {
    return BlockTopicListUseCase(
      key,
      ref.watch(topicRepositoryProvider),
      ref.watch(blockRepositoryProvider),
    );
  },
);

class BlockTopicListUseCase extends ChangeNotifier {
  BlockTopicListUseCase(
    this._key,
    this._topicRepository,
    this._blockRepository,
  ) {
    _blockTopicIdsSubscription =
        _blockRepository.getBlockTopicIdsStream().listen(
      (ids) {
        _blockTopicIds = ids;
      },
    );
    _blockTopicIds = _blockRepository.getBlockAnswerIds();
  }

  final TopicRepository _topicRepository;
  final BlockRepository _blockRepository;

  final UniqueKey _key;
  final _logger = Logger();

  bool hasNext = true;
  bool _isConnecting = false;
  Topics loadedTopics = const Topics(list: []);

  List<String> _blockTopicIds = [];
  StreamSubscription<List<String>>? _blockTopicIdsSubscription;

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

      if (topicResult is Success<Topic>) {
        loadedTopics = loadedTopics.added(topicResult.value);
      }
    }
    hasNext = _blockTopicIds.length == loadedTopics.length;
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
