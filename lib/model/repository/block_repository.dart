import 'package:meta/meta.dart';

abstract class BlockRepository {
  Stream<List<String>> getBlockUsersListStream();
  Stream<List<String>> getBlockAnswersListStream();
  Stream<List<String>> getBlockTopicsListStream();

  List<String> getBlockUsersList();
  List<String> getBlockAnswersList();
  List<String> getBlockTopicsList();

  Future<void> addBlockUser({@required String userId});
  Future<void> addBlockAnswer({@required String answerId});
  Future<void> addBlockTopic({@required String topicId});

  Future<void> removeBlockUser({@required String userId});
  Future<void> removeBlockAnswer({@required String answerId});
  Future<void> removeBlockTopic({@required String topicId});
}
