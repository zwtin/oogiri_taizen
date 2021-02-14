import 'package:oogiritaizen/model/entity/user_entity.dart';

abstract class UserUseCase {
  Stream<UserEntity> getLoginUserStream();
}
