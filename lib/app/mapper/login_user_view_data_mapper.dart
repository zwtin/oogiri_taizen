import 'package:oogiri_taizen/app/view_data/login_user_view_data.dart';
import 'package:oogiri_taizen/app/view_data/user_view_data.dart';
import 'package:oogiri_taizen/domain/entity/login_user.dart';
import 'package:oogiri_taizen/domain/entity/user.dart';

class LoginUserViewDataMapper {
  static LoginUserViewData convertToViewData({required LoginUser loginUser}) {
    final loginUserViewData = LoginUserViewData(
      id: loginUser.id,
      name: loginUser.name,
      imageUrl: loginUser.imageUrl,
      introduction: loginUser.introduction,
      emailVerified: loginUser.emailVerified,
    );
    return loginUserViewData;
  }

  static LoginUser convertToEntity(
      {required LoginUserViewData loginUserViewData}) {
    final loginUser = LoginUser(
      id: loginUserViewData.id,
      name: loginUserViewData.name,
      imageUrl: loginUserViewData.imageUrl,
      introduction: loginUserViewData.introduction,
      emailVerified: loginUserViewData.emailVerified,
    );
    return loginUser;
  }
}
