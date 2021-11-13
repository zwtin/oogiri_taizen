import 'package:freezed_annotation/freezed_annotation.dart';
part 'login_user_view_data.freezed.dart';

@freezed
class LoginUserViewData with _$LoginUserViewData {
  const factory LoginUserViewData({
    required String id,
    required String name,
    required String? imageUrl,
    required String introduction,
    required bool emailVerified,
  }) = _LoginUserViewData;
}
