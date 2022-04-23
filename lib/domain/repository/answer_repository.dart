import 'package:oogiri_taizen/domain/entity/answer.dart';
import 'package:oogiri_taizen/domain/entity/answers.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';

abstract class AnswerRepository {
  Future<Result<Answer>> getAnswer({
    required String id,
  });

  Future<Result<Answers>> getNewAnswers({
    required DateTime? offset,
    required int limit,
  });

  Future<Result<Answers>> getCreatedAnswers({
    required String userId,
    required DateTime? offset,
    required int limit,
  });

  Future<Result<Answers>> getFavorAnswers({
    required String userId,
    required DateTime? offset,
    required int limit,
  });
}
