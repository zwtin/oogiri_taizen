import 'package:meta/meta.dart';

import 'package:oogiritaizen/model/model/topic_model.dart';
import 'package:oogiritaizen/model/model/user_model.dart';

abstract class TopicRepository {
  Future<TopicModel> getTopic({
    @required String topicId,
  });

  Future<void> postTopic({
    @required UserModel user,
    @required TopicModel topic,
  });

  Future<List<TopicModel>> getNewTopicList({
    @required DateTime beforeTime,
    @required int count,
  });
}
