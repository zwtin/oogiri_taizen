import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/entity/topic.dart';

abstract class TopicRepository {
  Future<Result<Topic>> get({
    required String id,
  });
  Future<Result<void>> create({
    required Topic topic,
  });
  Future<Result<void>> update({
    required Topic topic,
  });
}
