import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_profile_view_data.freezed.dart';

@freezed
class MyProfileViewData with _$MyProfileViewData {
  const factory MyProfileViewData({
    required String id,
    required String name,
    String? imageUrl,
    required String introduction,
    required bool emailVerified,
  }) = _MyProfileViewData;
}
