import 'package:meta/meta.dart';
import 'package:oogiritaizen/model/entity/answer_entity.dart';
import 'package:oogiritaizen/model/entity/topic_entity.dart';
import 'package:oogiritaizen/model/entity/user_entity.dart';

abstract class BlockUseCase {
  Stream<List<TopicEntity>> getBlockTopicsListStream();
  Stream<List<AnswerEntity>> getBlockAnswersListStream();
  Stream<List<UserEntity>> getBlockUsersListStream();

  Future<List<TopicEntity>> getBlockTopicsList();
  Future<List<AnswerEntity>> getBlockAnswersList();
  Future<List<UserEntity>> getBlockUsersList();

  Future<void> addBlockTopic({@required String topicId});
  Future<void> addBlockAnswer({@required String answerId});
  Future<void> addBlockUser({@required String userId});

  Future<void> removeBlockTopic({@required String topicId});
  Future<void> removeBlockAnswer({@required String answerId});
  Future<void> removeBlockUser({@required String userId});
}
