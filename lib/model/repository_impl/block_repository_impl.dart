import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meta/meta.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'package:oogiritaizen/model/repository/block_repository.dart';

final blockRepositoryProvider = Provider<BlockRepository>(
  (ref) {
    final blockRepository = BlockRepositoryImpl();
    ref.onDispose(blockRepository.disposed);
    return blockRepository;
  },
);

class BlockRepositoryImpl implements BlockRepository {
  BlockRepositoryImpl() {
    setup();
  }

  Preference<List<String>> blockUsersListStream;
  Preference<List<String>> blockAnswersListStream;
  Preference<List<String>> blockTopicsListStream;

  Future<void> setup() async {
    WidgetsFlutterBinding.ensureInitialized();
    final preferences = await StreamingSharedPreferences.instance;
    blockUsersListStream =
        preferences.getStringList('blockUsersListStream', defaultValue: []);
    blockAnswersListStream =
        preferences.getStringList('blockAnswersListStream', defaultValue: []);
    blockTopicsListStream =
        preferences.getStringList('blockTopicsListStream', defaultValue: []);
  }

  @override
  Stream<List<String>> getBlockUsersListStream() {
    return blockUsersListStream;
  }

  @override
  Stream<List<String>> getBlockAnswersListStream() {
    return blockAnswersListStream;
  }

  @override
  Stream<List<String>> getBlockTopicsListStream() {
    return blockTopicsListStream;
  }

  @override
  List<String> getBlockUsersList() {
    return blockUsersListStream.getValue();
  }

  @override
  List<String> getBlockAnswersList() {
    return blockAnswersListStream.getValue();
  }

  @override
  List<String> getBlockTopicsList() {
    return blockTopicsListStream.getValue();
  }

  @override
  Future<void> addBlockUser({@required String userId}) async {
    final blockUsersList = blockUsersListStream.getValue();
    if (!blockUsersList.contains(userId)) {
      blockUsersList.add(userId);
    }
    await blockUsersListStream.setValue(blockUsersList);
  }

  @override
  Future<void> addBlockAnswer({@required String answerId}) async {
    final blockAnswersList = blockAnswersListStream.getValue();
    if (!blockAnswersList.contains(answerId)) {
      blockAnswersList.add(answerId);
    }
    await blockAnswersListStream.setValue(blockAnswersList);
  }

  @override
  Future<void> addBlockTopic({@required String topicId}) async {
    final blockTopicsList = blockTopicsListStream.getValue();
    if (!blockTopicsList.contains(topicId)) {
      blockTopicsList.add(topicId);
    }
    await blockTopicsListStream.setValue(blockTopicsList);
  }

  @override
  Future<void> removeBlockUser({@required String userId}) async {
    final blockUsersList = blockUsersListStream.getValue();
    if (blockUsersList.contains(userId)) {
      blockUsersList.remove(userId);
    }
    await blockUsersListStream.setValue(blockUsersList);
  }

  @override
  Future<void> removeBlockAnswer({@required String answerId}) async {
    final blockAnswersList = blockAnswersListStream.getValue();
    if (blockAnswersList.contains(answerId)) {
      blockAnswersList.remove(answerId);
    }
    await blockAnswersListStream.setValue(blockAnswersList);
  }

  @override
  Future<void> removeBlockTopic({@required String topicId}) async {
    final blockTopicsList = blockTopicsListStream.getValue();
    if (blockTopicsList.contains(topicId)) {
      blockTopicsList.remove(topicId);
    }
    await blockTopicsListStream.setValue(blockTopicsList);
  }

  Future<void> disposed() async {}
}
