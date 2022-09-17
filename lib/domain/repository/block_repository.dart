import 'package:oogiri_taizen/domain/entity/result.dart';

abstract class BlockRepository {
  Stream<List<String>> getBlockUserIdsStream();
  Future<Result<List<String>>> getBlockUserIds();
  Future<Result<void>> addBlockUserId({required String userId});
  Future<Result<void>> removeBlockUserId({required String userId});

  Stream<List<String>> getBlockTopicIdsStream();
  Future<Result<List<String>>> getBlockTopicIds();
  Future<Result<void>> addBlockTopicId({required String topicId});
  Future<Result<void>> removeBlockTopicId({required String topicId});

  Stream<List<String>> getBlockAnswerIdsStream();
  Future<Result<List<String>>> getBlockAnswerIds();
  Future<Result<void>> addBlockAnswerId({required String answerId});
  Future<Result<void>> removeBlockAnswerId({required String answerId});
}
