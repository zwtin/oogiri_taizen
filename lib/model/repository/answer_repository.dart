import 'package:meta/meta.dart';

import 'package:oogiritaizen/model/model/answer_model.dart';

abstract class AnswerRepository {
  Future<AnswerModel> getAnswer({
    @required String answerId,
  });

  Future<void> postAnswer({
    @required String userId,
    @required String topicId,
    @required AnswerModel answer,
  });

  Future<List<AnswerModel>> getNewAnswerList({
    @required DateTime beforeTime,
    @required int count,
  });
}
