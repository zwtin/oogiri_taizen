import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/repository/block_repository.dart';
import 'package:oogiri_taizen/infra/repository_impl/streaming_shared_preferences.dart';

final blockRepositoryProvider = Provider.autoDispose<BlockRepository>(
  (ref) {
    final blockRepository = BlockRepositoryImpl(
      ref.watch(sharedPreferencesProvider),
    );
    ref.onDispose(blockRepository.disposed);
    return blockRepository;
  },
);

class BlockRepositoryImpl implements BlockRepository {
  BlockRepositoryImpl(
    this._instance,
  );

  final StreamingSharedPreferences _instance;

  @override
  Stream<List<String>> getBlockUserIdsStream() {
    return _instance.getStringList('BlockUsers', defaultValue: []);
  }

  @override
  List<String> getBlockUserIds() {
    return _instance.getStringList('BlockUsers', defaultValue: []).getValue();
  }

  @override
  Future<Result<void>> addBlockUserId({required String userId}) async {
    try {
      final list =
          _instance.getStringList('BlockUsers', defaultValue: []).getValue();
      if (list.contains(userId)) {
        throw OTException();
      }
      list.add(userId);
      await _instance.setStringList('BlockUsers', list);
      return const Result.success(null);
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  @override
  Future<Result<void>> removeBlockUserId({required String userId}) async {
    try {
      final list =
          _instance.getStringList('BlockUsers', defaultValue: []).getValue();
      if (!list.contains(userId)) {
        throw OTException();
      }
      list.remove(userId);
      await _instance.setStringList('BlockUsers', list);
      return const Result.success(null);
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  @override
  Stream<List<String>> getBlockTopicIdsStream() {
    return _instance.getStringList('BlockTopics', defaultValue: []);
  }

  @override
  List<String> getBlockTopicIds() {
    return _instance.getStringList('BlockTopics', defaultValue: []).getValue();
  }

  @override
  Future<Result<void>> addBlockTopicId({required String topicId}) async {
    try {
      final list =
          _instance.getStringList('BlockTopics', defaultValue: []).getValue();
      if (list.contains(topicId)) {
        throw OTException();
      }
      list.add(topicId);
      await _instance.setStringList('BlockTopics', list);
      return const Result.success(null);
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  @override
  Future<Result<void>> removeBlockTopicId({required String topicId}) async {
    try {
      final list =
          _instance.getStringList('BlockTopics', defaultValue: []).getValue();
      if (!list.contains(topicId)) {
        throw OTException();
      }
      list.remove(topicId);
      await _instance.setStringList('BlockTopics', list);
      return const Result.success(null);
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  @override
  Stream<List<String>> getBlockAnswerIdsStream() {
    return _instance.getStringList('BlockAnswers', defaultValue: []);
  }

  @override
  List<String> getBlockAnswerIds() {
    return _instance.getStringList('BlockAnswers', defaultValue: []).getValue();
  }

  @override
  Future<Result<void>> addBlockAnswerId({required String answerId}) async {
    try {
      final list =
          _instance.getStringList('BlockAnswers', defaultValue: []).getValue();
      if (list.contains(answerId)) {
        throw OTException();
      }
      list.add(answerId);
      await _instance.setStringList('BlockAnswers', list);
      return const Result.success(null);
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  @override
  Future<Result<void>> removeBlockAnswerId({required String answerId}) async {
    try {
      final list =
          _instance.getStringList('BlockAnswers', defaultValue: []).getValue();
      if (!list.contains(answerId)) {
        throw OTException();
      }
      list.remove(answerId);
      await _instance.setStringList('BlockAnswers', list);
      return const Result.success(null);
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  Future<void> disposed() async {
    debugPrint('BlockRepositoryImpl disposed');
  }
}
