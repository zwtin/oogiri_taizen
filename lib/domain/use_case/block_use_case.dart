import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/domain/entity/answer.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/entity/topic.dart';
import 'package:oogiri_taizen/domain/entity/user.dart';
import 'package:oogiri_taizen/domain/repository/block_repository.dart';
import 'package:oogiri_taizen/infra/repository_impl/block_repository_impl.dart';

final blockUseCaseProvider =
    Provider.autoDispose.family<BlockUseCase, UniqueKey>(
  (ref, key) {
    return BlockUseCase(
      key,
      ref.watch(blockRepositoryProvider),
    );
  },
);

class BlockUseCase extends ChangeNotifier {
  BlockUseCase(
    this._key,
    this._blockRepository,
  );

  final BlockRepository _blockRepository;

  final UniqueKey _key;
  final _logger = Logger();

  Future<Result<void>> addUser({required User user}) async {
    final list = _blockRepository.getBlockUserIds();
    if (list.contains(user.id)) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: 'すでにブロック済みです',
        ),
      );
    }
    final result = await _blockRepository.addBlockUserId(userId: user.id);
    if (result is Failure) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: 'ブロックに失敗しました',
        ),
      );
    }
    return const Result.success(null);
  }

  Future<Result<void>> removeUser({required User user}) async {
    final list = _blockRepository.getBlockUserIds();
    if (!list.contains(user.id)) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: 'ブロックされていません',
        ),
      );
    }
    final result = await _blockRepository.removeBlockUserId(userId: user.id);
    if (result is Failure) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: 'ブロックの解除に失敗しました',
        ),
      );
    }
    return const Result.success(null);
  }

  Future<Result<void>> addTopic({required Topic topic}) async {
    final list = _blockRepository.getBlockTopicIds();
    if (list.contains(topic.id)) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: 'すでにブロック済みです',
        ),
      );
    }
    final result = await _blockRepository.addBlockTopicId(topicId: topic.id);
    if (result is Failure) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: 'ブロックに失敗しました',
        ),
      );
    }
    return const Result.success(null);
  }

  Future<Result<void>> removeTopic({required Topic topic}) async {
    final list = _blockRepository.getBlockTopicIds();
    if (!list.contains(topic.id)) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: 'ブロックされていません',
        ),
      );
    }
    final result = await _blockRepository.removeBlockTopicId(topicId: topic.id);
    if (result is Failure) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: 'ブロックの解除に失敗しました',
        ),
      );
    }
    return const Result.success(null);
  }

  Future<Result<void>> addAnswer({required Answer answer}) async {
    final list = _blockRepository.getBlockAnswerIds();
    if (list.contains(answer.id)) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: 'すでにブロック済みです',
        ),
      );
    }
    final result = await _blockRepository.addBlockAnswerId(answerId: answer.id);
    if (result is Failure) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: 'ブロックに失敗しました',
        ),
      );
    }
    return const Result.success(null);
  }

  Future<Result<void>> removeAnswer({required Answer answer}) async {
    final list = _blockRepository.getBlockAnswerIds();
    if (!list.contains(answer.id)) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: 'ブロックされていません',
        ),
      );
    }
    final result =
        await _blockRepository.removeBlockAnswerId(answerId: answer.id);
    if (result is Failure) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: 'ブロックの解除に失敗しました',
        ),
      );
    }
    return const Result.success(null);
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('BlockUseCase dispose $_key');
  }
}
