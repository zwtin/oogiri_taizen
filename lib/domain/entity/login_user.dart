import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oogiri_taizen/domain/entity/user.dart';

part 'login_user.freezed.dart';

@freezed
abstract class LoginUser implements _$LoginUser {
  const factory LoginUser({
    required User user,
    required bool emailVerified,
  }) = _LoginUser;
  const LoginUser._();

  String get id => user.id;
  String get name => user.name;
  String? get imageUrl => user.imageUrl;
  String get introduction => user.introduction;
}
