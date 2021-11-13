import 'package:oogiri_taizen/app/view_data/user_view_data.dart';
import 'package:oogiri_taizen/domain/entity/user.dart';

class UserViewDataMapper {
  static UserViewData convertToViewData({required User user}) {
    final userViewData = UserViewData(
      id: user.id,
      name: user.name,
      imageUrl: user.imageUrl,
      introduction: user.introduction,
    );
    return userViewData;
  }

  static User convertToEntity({required UserViewData userViewData}) {
    final user = User(
      id: userViewData.id,
      name: userViewData.name,
      imageUrl: userViewData.imageUrl,
      introduction: userViewData.introduction,
    );
    return user;
  }
}
