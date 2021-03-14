import 'package:meta/meta.dart';

import 'package:oogiritaizen/model/model/user_model.dart';

abstract class UserRepository {
  Future<void> createUser({
    @required String userId,
  });

  Stream<UserModel> getUserStream({
    @required String userId,
  });

  Future<UserModel> getUser({
    @required String userId,
  });

  Future<void> updateUser({
    @required UserModel user,
  });

  Future<List<String>> getCreateAnswers({
    @required String userId,
    @required DateTime beforeTime,
    @required int count,
  });

  Future<List<String>> getFavorAnswers({
    @required String userId,
    @required DateTime beforeTime,
    @required int count,
  });
}
