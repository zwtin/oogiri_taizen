import 'package:oogiri_taizen/domain/entity/user.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';

abstract class UserUseCase {
  Stream<User> getStream();
  Future<Result<void>> getUser();
}
