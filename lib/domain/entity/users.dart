import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oogiri_taizen/domain/entity/user.dart';
part 'users.freezed.dart';

@freezed
class Users with _$Users {
  const factory Users({
    required List<User> list,
    required bool hasNext,
  }) = _Users;
}
