import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/entity/user.dart';

abstract class UserRepository {
  Future<Result<User>> getUser({
    required String id,
  });
  Stream<User?> getUserStream({
    required String id,
  });
  Future<Result<void>> createUser({
    required String id,
  });
  Future<Result<void>> updateUser({
    required String id,
    required String? name,
    required String? imageUrl,
    required String? introduction,
  });
}
