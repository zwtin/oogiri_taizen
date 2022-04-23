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

  Users added(User user) {
    final newList = List.of(list)..add(user);
    return Users(list: newList);
  }

  Users removedLast() {
    final newList = List.of(list)..removeLast();
    return Users(list: newList);
  }

  User? getByIndex(int index) {
    if (index < list.length) {
      return list[index];
    } else {
      return null;
    }
  }

  User? getById(String id) {
    if (list.any((element) => element.id == id)) {
      return list.firstWhere((element) => element.id == id);
    } else {
      return null;
    }
  }
}
