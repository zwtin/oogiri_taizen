import 'package:oogiri_taizen/app/view_data/user_profile_view_data.dart';
import 'package:oogiri_taizen/domain/entity/user.dart';

UserProfileViewData mappingForUserProfileViewData({
  required User user,
}) {
  return UserProfileViewData(
    id: user.id,
    name: user.name,
    imageUrl: user.imageUrl,
    introduction: user.introduction,
  );
}
