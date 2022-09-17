import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/repository/block_repository.dart';
import 'package:oogiri_taizen/temporary_provider.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

final blockRepositoryProvider = Provider.autoDispose<BlockRepository>(
  (ref) {
    final blockRepository = BlockRepositoryImpl(
      ref.watch(sharedPreferencesProvider),
    );
    ref.onDispose(blockRepository.dispose);
    return blockRepository;
  },
);

class BlockRepositoryImpl implements BlockRepository {
  BlockRepositoryImpl(
    this._instance,
  );

  final _logger = Logger();
  final StreamingSharedPreferences _instance;

  @override
  Stream<List<String>> getBlockUserIdsStream() {
    return _instance.getStringList('BlockUsers', defaultValue: []);
  }

  @override
  Future<Result<List<String>>> getBlockUserIds() async {
    final list =
        _instance.getStringList('BlockUsers', defaultValue: []).getValue();
    return Result.success(list);
  }

  @override
  Future<Result<void>> addBlockUserId({required String userId}) async {
    try {
      final list =
          _instance.getStringList('BlockUsers', defaultValue: []).getValue();
      if (list.contains(userId)) {
        throw OTException(text: 'エラー', title: 'ブロックユーザーの追加に失敗しました');
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
        throw OTException(text: 'エラー', title: 'ブロックユーザーの削除に失敗しました');
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
  Future<Result<List<String>>> getBlockTopicIds() async {
    final list =
        _instance.getStringList('BlockTopics', defaultValue: []).getValue();
    return Result.success(list);
  }

  @override
  Future<Result<void>> addBlockTopicId({required String topicId}) async {
    try {
      final list =
          _instance.getStringList('BlockTopics', defaultValue: []).getValue();
      if (list.contains(topicId)) {
        throw OTException(text: 'エラー', title: 'ブロックお題の追加に失敗しました');
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
        throw OTException(text: 'エラー', title: 'ブロックお題の削除に失敗しました');
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
  Future<Result<List<String>>> getBlockAnswerIds() async {
    final list =
        _instance.getStringList('BlockAnswers', defaultValue: []).getValue();
    return Result.success(list);
  }

  @override
  Future<Result<void>> addBlockAnswerId({required String answerId}) async {
    try {
      final list =
          _instance.getStringList('BlockAnswers', defaultValue: []).getValue();
      if (list.contains(answerId)) {
        throw OTException(text: 'エラー', title: 'ブロックボケの追加に失敗しました');
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
        throw OTException(text: 'エラー', title: 'ブロックボケの削除に失敗しました');
      }
      list.remove(answerId);
      await _instance.setStringList('BlockAnswers', list);
      return const Result.success(null);
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  void dispose() {
    _logger.d('BlockRepositoryImpl dispose');
  }
}
