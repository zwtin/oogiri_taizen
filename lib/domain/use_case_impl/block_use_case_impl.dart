import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:oogiri_taizen/domain/entity/answer.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/entity/topic.dart';
import 'package:oogiri_taizen/domain/entity/user.dart';
import 'package:oogiri_taizen/domain/repository/block_repository.dart';
import 'package:oogiri_taizen/domain/use_case/block_use_case.dart';
import 'package:oogiri_taizen/infra/repository_impl/block_repository_impl.dart';

final blockUseCaseProvider = Provider.autoDispose<BlockUseCase>(
  (ref) {
    final blockUseCase = BlockUseCaseImpl(
      ref.watch(blockRepositoryProvider),
    );
    ref.onDispose(blockUseCase.disposed);
    return blockUseCase;
  },
);

class BlockUseCaseImpl implements BlockUseCase {
  BlockUseCaseImpl(
    this.blockRepository,
  );

  final BlockRepository blockRepository;

  @override
  Stream<List<String>> getBlockUserIdsStream() {
    return blockRepository.getBlockUserIdsStream();
  }

  @override
  Future<Result<void>> addUser({required User user}) async {
    final list = blockRepository.getBlockUserIds();
    if (list.contains(user.id)) {
      return Result.failure(OTException(alertMessage: 'すでにブロック済みです'));
    }
    final result = await blockRepository.addBlockUserId(userId: user.id);
    if (result is Failure) {
      return Result.failure(OTException(alertMessage: 'ブロックに失敗しました'));
    }
    return const Result.success(null);
  }

  @override
  Future<Result<void>> removeUser({required User user}) async {
    final list = blockRepository.getBlockUserIds();
    if (!list.contains(user.id)) {
      return Result.failure(OTException(alertMessage: 'ブロックされていません'));
    }
    final result = await blockRepository.removeBlockUserId(userId: user.id);
    if (result is Failure) {
      return Result.failure(OTException(alertMessage: 'ブロックの解除に失敗しました'));
    }
    return const Result.success(null);
  }

  @override
  Stream<List<String>> getBlockTopicIdsStream() {
    return blockRepository.getBlockTopicIdsStream();
  }

  @override
  Future<Result<void>> addTopic({required Topic topic}) async {
    final list = blockRepository.getBlockTopicIds();
    if (list.contains(topic.id)) {
      return Result.failure(OTException(alertMessage: 'すでにブロック済みです'));
    }
    final result = await blockRepository.addBlockTopicId(topicId: topic.id);
    if (result is Failure) {
      return Result.failure(OTException(alertMessage: 'ブロックに失敗しました'));
    }
    return const Result.success(null);
  }

  @override
  Future<Result<void>> removeTopic({required Topic topic}) async {
    final list = blockRepository.getBlockTopicIds();
    if (!list.contains(topic.id)) {
      return Result.failure(OTException(alertMessage: 'ブロックされていません'));
    }
    final result = await blockRepository.removeBlockTopicId(topicId: topic.id);
    if (result is Failure) {
      return Result.failure(OTException(alertMessage: 'ブロックの解除に失敗しました'));
    }
    return const Result.success(null);
  }

  @override
  Stream<List<String>> getBlockAnswerIdsStream() {
    return blockRepository.getBlockAnswerIdsStream();
  }

  @override
  Future<Result<void>> addAnswer({required Answer answer}) async {
    final list = blockRepository.getBlockAnswerIds();
    if (list.contains(answer.id)) {
      return Result.failure(OTException(alertMessage: 'すでにブロック済みです'));
    }
    final result = await blockRepository.addBlockAnswerId(answerId: answer.id);
    if (result is Failure) {
      return Result.failure(OTException(alertMessage: 'ブロックに失敗しました'));
    }
    return const Result.success(null);
  }

  @override
  Future<Result<void>> removeAnswer({required Answer answer}) async {
    final list = blockRepository.getBlockAnswerIds();
    if (!list.contains(answer.id)) {
      return Result.failure(OTException(alertMessage: 'ブロックされていません'));
    }
    final result =
        await blockRepository.removeBlockAnswerId(answerId: answer.id);
    if (result is Failure) {
      return Result.failure(OTException(alertMessage: 'ブロックの解除に失敗しました'));
    }
    return const Result.success(null);
  }

  Future<void> disposed() async {
    debugPrint('BlockUseCaseImpl disposed');
  }
}
