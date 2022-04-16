import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
abstract class User implements _$User {
  const factory User({
    required String id,
    required String name,
    required String? imageUrl,
    required String introduction,
  }) = _User;
  const User._();
}
