import 'package:meta/meta.dart';

import 'package:oogiritaizen/model/model/topic_model.dart';

abstract class TopicRepository {
  Future<TopicModel> getTopic({
    @required String topicId,
  });

  Future<void> postTopic({
    @required String userId,
    @required TopicModel topic,
  });

  Future<List<TopicModel>> getNewTopicList({
    @required DateTime beforeTime,
    @required int count,
  });
}
