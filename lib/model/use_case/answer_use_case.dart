import 'package:meta/meta.dart';
import 'package:oogiritaizen/model/entity/answer_entity.dart';
import 'package:oogiritaizen/model/entity/answer_list_entity.dart';

abstract class AnswerUseCase {
  Future<AnswerEntity> getAnswer({
    @required String answerId,
  });

  Future<void> postAnswer({
    @required String topicId,
    @required AnswerEntity editedAnswer,
  });

  Future<AnswerListEntity> getNewAnswerList({
    @required DateTime beforeTime,
  });
}
