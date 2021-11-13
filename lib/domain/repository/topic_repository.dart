import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/entity/topic.dart';

abstract class TopicRepository {
  Future<Result<Topic>> getTopic({
    required String id,
  });
}
