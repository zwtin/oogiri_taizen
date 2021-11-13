import 'package:oogiri_taizen/domain/entity/answer.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';

abstract class AnswerUseCase {
  Stream<Answer?> getAnswerStream();
  Future<Result<void>> resetAnswer();
  Future<Result<void>> fetchAnswer();
}
