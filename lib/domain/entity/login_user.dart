import 'package:freezed_annotation/freezed_annotation.dart';
part 'login_user.freezed.dart';

@freezed
class LoginUser with _$LoginUser {
  const factory LoginUser({
    required String id,
    required String name,
    required String? imageUrl,
    required String introduction,
    required bool emailVerified,
  }) = _LoginUser;
}
