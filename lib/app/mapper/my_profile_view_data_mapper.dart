import 'package:oogiri_taizen/app/view_data/my_profile_view_data.dart';
import 'package:oogiri_taizen/domain/entity/login_user.dart';

MyProfileViewData? mappingForMyProfileViewData({
  required LoginUser loginUser,
}) {
  if (loginUser.user == null) {
    return null;
  }
  return MyProfileViewData(
    id: loginUser.id,
    name: loginUser.user!.name,
    imageUrl: loginUser.user!.imageUrl,
    introduction: loginUser.user!.introduction,
    emailVerified: loginUser.emailVerified,
  );
}
