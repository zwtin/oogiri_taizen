import 'package:oogiri_taizen/domain/entity/answer.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/entity/topic.dart';
import 'package:oogiri_taizen/domain/entity/user.dart';

abstract class BlockUseCase {
  Future<Result<void>> addUser({required User user});
  Future<Result<void>> removeUser({required User user});

  Future<Result<void>> addTopic({required Topic topic});
  Future<Result<void>> removeTopic({required Topic topic});

  Future<Result<void>> addAnswer({required Answer answer});
  Future<Result<void>> removeAnswer({required Answer answer});
}
