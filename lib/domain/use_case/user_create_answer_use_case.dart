import 'package:oogiri_taizen/domain/entity/answers.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';

abstract class UserCreateAnswerUseCase {
  Stream<Answers> getAnswersStream();
  Future<Result<void>> resetAnswers();
  Future<Result<void>> fetchAnswers();
}
