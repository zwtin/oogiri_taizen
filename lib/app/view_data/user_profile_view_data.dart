import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile_view_data.freezed.dart';

@freezed
class UserProfileViewData with _$UserProfileViewData {
  const factory UserProfileViewData({
    required String id,
    required String name,
    required String? imageUrl,
    required String introduction,
  }) = _UserProfileViewData;
}
