import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meta/meta.dart';
import 'package:oogiritaizen/model/use_case/block_use_case.dart';

import 'package:oogiritaizen/model/repository/block_repository.dart';
import 'package:oogiritaizen/model/repository_impl/block_repository_impl.dart';

final blockUseCaseProvider = Provider.autoDispose.family<BlockUseCase, String>(
  (ref, id) {
    final blockUseCase = BlockUseCaseImpl(
      id,
      ref.watch(blockRepositoryProvider),
    );
    ref.onDispose(blockUseCase.disposed);
    return blockUseCase;
  },
);

class BlockUseCaseImpl implements BlockUseCase {
  BlockUseCaseImpl(
    this.id,
    this.blockRepository,
  );

  final String id;
  final BlockRepository blockRepository;

  @override
  Stream<List<String>> getBlockUsersListStream() {
    return blockRepository.getBlockUsersListStream();
  }

  @override
  Stream<List<String>> getBlockAnswersListStream() {
    return blockRepository.getBlockAnswersListStream();
  }

  @override
  Stream<List<String>> getBlockTopicsListStream() {
    return blockRepository.getBlockTopicsListStream();
  }

  @override
  List<String> getBlockUsersList() {
    return blockRepository.getBlockUsersList();
  }

  @override
  List<String> getBlockAnswersList() {
    return blockRepository.getBlockAnswersList();
  }

  @override
  List<String> getBlockTopicsList() {
    return blockRepository.getBlockTopicsList();
  }

  @override
  Future<void> addBlockUser({@required String userId}) async {
    await blockRepository.addBlockUser(userId: userId);
  }

  @override
  Future<void> addBlockAnswer({@required String answerId}) async {
    await blockRepository.addBlockAnswer(answerId: answerId);
  }

  @override
  Future<void> addBlockTopic({@required String topicId}) async {
    await blockRepository.addBlockTopic(topicId: topicId);
  }

  @override
  Future<void> removeBlockUser({@required String userId}) async {
    await blockRepository.removeBlockUser(userId: userId);
  }

  @override
  Future<void> removeBlockAnswer({@required String answerId}) async {
    await blockRepository.removeBlockAnswer(answerId: answerId);
  }

  @override
  Future<void> removeBlockTopic({@required String topicId}) async {
    await blockRepository.removeBlockTopic(topicId: topicId);
  }

  Future<void> disposed() async {}
}
