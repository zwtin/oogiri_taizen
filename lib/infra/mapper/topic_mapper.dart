import 'package:oogiri_taizen/domain/entity/topic.dart';
import 'package:oogiri_taizen/domain/entity/user.dart';
import 'package:oogiri_taizen/infra/dao/topic_dao.dart';

class TopicMapper {
  TopicMapper._() {
    throw AssertionError('private Constructor');
  }

  static Topic mappingFromDAO({
    required TopicDAO topicDAO,
    required User createdUser,
  }) {
    return Topic(
      id: topicDAO.id,
      text: topicDAO.text,
      imageUrl: topicDAO.imageUrl,
      answeredCount: topicDAO.answeredCount,
      createdUser: createdUser,
      createdAt: topicDAO.createdAt,
    );
  }

  static TopicDAO mappingToDAO({
    required Topic topic,
  }) {
    return TopicDAO(
      id: topic.id,
      text: topic.text,
      imageUrl: topic.imageUrl,
      answeredCount: topic.answeredCount,
      createdUserId: topic.createdUser.id,
      createdAt: topic.createdAt,
    );
  }
}
