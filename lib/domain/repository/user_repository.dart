import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/entity/user.dart';

abstract class UserRepository {
  Future<Result<User>> get({
    required String id,
  });
  Future<Result<void>> create({
    required User user,
  });
  Future<Result<void>> update({
    required User user,
  });
}
