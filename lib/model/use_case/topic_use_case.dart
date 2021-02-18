import 'dart:io';

import 'package:meta/meta.dart';
import 'package:oogiritaizen/model/entity/topic_entity.dart';
import 'package:oogiritaizen/model/entity/topic_list_entity.dart';

abstract class TopicUseCase {
  Future<TopicEntity> getTopic({
    @required String topicId,
  });

  Future<void> postTopic({
    @required File imageFile,
    @required TopicEntity editedTopic,
  });

  Future<TopicListEntity> getNewTopicList({
    @required DateTime beforeTime,
  });
}
