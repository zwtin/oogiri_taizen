import 'package:oogiri_taizen/domain/entity/user.dart';
import 'package:oogiri_taizen/infra/dao/user_dao.dart';

class UserMapper {
  UserMapper._() {
    throw AssertionError('private Constructor');
  }

  static User mappingFromDAO({
    required UserDAO userDAO,
  }) {
    return User(
      id: userDAO.id,
      name: userDAO.name,
      imageUrl: userDAO.imageUrl,
      introduction: userDAO.introduction,
    );
  }

  static UserDAO mappingToDAO({
    required User user,
  }) {
    return UserDAO(
      id: user.id,
      name: user.name,
      imageUrl: user.imageUrl,
      introduction: user.introduction,
    );
  }
}
