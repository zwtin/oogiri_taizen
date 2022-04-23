import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/entity/topic.dart';
import 'package:oogiri_taizen/domain/repository/topic_repository.dart';
import 'package:oogiri_taizen/infra/mapper/topic_mapper.dart';

final topicRepositoryProvider = Provider.autoDispose<TopicRepository>(
  (ref) {
    final topicRepository = TopicRepositoryImpl();
    ref.onDispose(topicRepository.dispose);
    return topicRepository;
  },
);

class TopicRepositoryImpl implements TopicRepository {
  final _logger = Logger();
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<Result<Topic>> getTopic({
    required String id,
  }) async {
    try {
      final topicDoc = await _firestore.collection('topics').doc(id).get();
      final topicData = topicDoc.data();
      if (topicData == null) {
        throw OTException(title: 'エラー', text: 'お題の取得に失敗しました');
      }
      final topic = mappingForTopic(
        topicData: topicData,
      );
      return Result.success(topic);
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  void dispose() {
    _logger.d('TopicRepositoryImpl dispose');
  }
}
