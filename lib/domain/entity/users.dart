import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oogiri_taizen/domain/entity/user.dart';

part 'users.freezed.dart';

@freezed
abstract class Users implements _$Users {
  const factory Users({
    required List<User> list,
  }) = _Users;
  const Users._();

  int get length => list.length;
  bool get isEmpty => list.isEmpty;
  User? get firstOrNull => list.firstOrNull;
  User? get lastOrNull => list.lastOrNull;
}
