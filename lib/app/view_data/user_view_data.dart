import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_view_data.freezed.dart';

@freezed
class UserViewData with _$UserViewData {
  const factory UserViewData({
    required String id,
    required String name,
    required String? imageUrl,
    required String introduction,
  }) = _UserViewData;
}
