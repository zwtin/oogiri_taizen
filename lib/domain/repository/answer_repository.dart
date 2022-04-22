import 'package:oogiri_taizen/domain/entity/answer.dart';
import 'package:oogiri_taizen/domain/entity/answers.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';

abstract class AnswerRepository {
  Future<Result<Answer>> getAnswer({
    required String id,
  });

  Future<Result<Answers>> getNewAnswerIds({
    required DateTime? offset,
    required int limit,
  });

  Future<Result<Answers>> getCreatedAnswerIds({
    required String userId,
    required DateTime? offset,
    required int limit,
  });

  Future<Result<Answers>> getFavorAnswerIds({
    required String userId,
    required DateTime? offset,
    required int limit,
  });
}
