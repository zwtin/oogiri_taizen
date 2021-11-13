import 'package:oogiri_taizen/domain/entity/answer.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';

abstract class AnswerRepository {
  Future<Result<Answer>> getAnswer({
    required String id,
  });

  Future<Result<List<String>>> getNewAnswerIds({
    required DateTime? offset,
    required int limit,
  });

  Future<Result<List<String>>> getCreatedAnswerIds({
    required String userId,
    required DateTime? offset,
    required int limit,
  });

  Future<Result<List<String>>> getFavorAnswerIds({
    required String userId,
    required DateTime? offset,
    required int limit,
  });
}
