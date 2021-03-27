import 'package:meta/meta.dart';

abstract class BlockUseCase {
  Stream<List<String>> getBlockUsersListStream();
  Stream<List<String>> getBlockAnswersListStream();
  Stream<List<String>> getBlockTopicsListStream();

  Future<void> addBlockUser({@required String userId});
  Future<void> addBlockAnswer({@required String answerId});
  Future<void> addBlockTopic({@required String topicId});

  Future<void> removeBlockUser({@required String userId});
  Future<void> removeBlockAnswer({@required String answerId});
  Future<void> removeBlockTopic({@required String topicId});
}
