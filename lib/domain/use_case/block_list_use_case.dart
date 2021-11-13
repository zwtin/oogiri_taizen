import 'package:oogiri_taizen/domain/entity/answer.dart';
import 'package:oogiri_taizen/domain/entity/answers.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/entity/topic.dart';
import 'package:oogiri_taizen/domain/entity/topics.dart';
import 'package:oogiri_taizen/domain/entity/user.dart';
import 'package:oogiri_taizen/domain/entity/users.dart';

abstract class BlockListUseCase {
  Stream<Answers> getAnswersStream();
  Future<Result<void>> resetAnswers();
  Future<Result<void>> fetchAnswers();
  Future<Result<void>> removeAnswer({required Answer answer});

  Stream<Topics> getTopicsStream();
  Future<Result<void>> resetTopics();
  Future<Result<void>> fetchTopics();
  Future<Result<void>> removeTopic({required Topic topic});

  Stream<Users> getUsersStream();
  Future<Result<void>> resetUsers();
  Future<Result<void>> fetchUsers();
  Future<Result<void>> removeUser({required User user});
}
