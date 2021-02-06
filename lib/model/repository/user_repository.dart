import 'package:meta/meta.dart';

import 'package:oogiritaizen/model/model/user_model.dart';

abstract class UserRepository {
  Stream<UserModel> getUserStream({
    @required String userId,
  });

  Future<UserModel> getUser({
    @required String userId,
  });

  Future<void> updateUser({
    @required String userId,
    @required UserModel user,
  });
}
