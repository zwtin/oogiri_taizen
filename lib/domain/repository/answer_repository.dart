import 'package:oogiri_taizen/domain/entity/answer.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';

abstract class AnswerRepository {
  Future<Result<Answer>> get({
    required String id,
  });
  Future<Result<void>> create({
    required Answer answer,
  });
  Future<Result<void>> update({
    required Answer answer,
  });
}
