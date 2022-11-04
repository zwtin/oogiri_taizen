// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'login_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$LoginUserTearOff {
  const _$LoginUserTearOff();

  _LoginUser call({required User user, required bool emailVerified}) {
    return _LoginUser(
      user: user,
      emailVerified: emailVerified,
    );
  }
}

/// @nodoc
const $LoginUser = _$LoginUserTearOff();

/// @nodoc
mixin _$LoginUser {
  User get user => throw _privateConstructorUsedError;
  bool get emailVerified => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LoginUserCopyWith<LoginUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginUserCopyWith<$Res> {
  factory $LoginUserCopyWith(LoginUser value, $Res Function(LoginUser) then) =
      _$LoginUserCopyWithImpl<$Res>;
  $Res call({User user, bool emailVerified});

  $UserCopyWith<$Res> get user;
}

/// @nodoc
class _$LoginUserCopyWithImpl<$Res> implements $LoginUserCopyWith<$Res> {
  _$LoginUserCopyWithImpl(this._value, this._then);

  final LoginUser _value;
  // ignore: unused_field
  final $Res Function(LoginUser) _then;

  @override
  $Res call({
    Object? user = freezed,
    Object? emailVerified = freezed,
  }) {
    return _then(_value.copyWith(
      user: user == freezed
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
      emailVerified: emailVerified == freezed
          ? _value.emailVerified
          : emailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  @override
  $UserCopyWith<$Res> get user {
    return $UserCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value));
    });
  }
}

/// @nodoc
abstract class _$LoginUserCopyWith<$Res> implements $LoginUserCopyWith<$Res> {
  factory _$LoginUserCopyWith(
          _LoginUser value, $Res Function(_LoginUser) then) =
      __$LoginUserCopyWithImpl<$Res>;
  @override
  $Res call({User user, bool emailVerified});

  @override
  $UserCopyWith<$Res> get user;
}

/// @nodoc
class __$LoginUserCopyWithImpl<$Res> extends _$LoginUserCopyWithImpl<$Res>
    implements _$LoginUserCopyWith<$Res> {
  __$LoginUserCopyWithImpl(_LoginUser _value, $Res Function(_LoginUser) _then)
      : super(_value, (v) => _then(v as _LoginUser));

  @override
  _LoginUser get _value => super._value as _LoginUser;

  @override
  $Res call({
    Object? user = freezed,
    Object? emailVerified = freezed,
  }) {
    return _then(_LoginUser(
      user: user == freezed
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
      emailVerified: emailVerified == freezed
          ? _value.emailVerified
          : emailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_LoginUser extends _LoginUser {
  const _$_LoginUser({required this.user, required this.emailVerified})
      : super._();

  @override
  final User user;
  @override
  final bool emailVerified;

  @override
  String toString() {
    return 'LoginUser(user: $user, emailVerified: $emailVerified)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _LoginUser &&
            (identical(other.user, user) ||
                const DeepCollectionEquality().equals(other.user, user)) &&
            (identical(other.emailVerified, emailVerified) ||
                const DeepCollectionEquality()
                    .equals(other.emailVerified, emailVerified)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(user) ^
      const DeepCollectionEquality().hash(emailVerified);

  @JsonKey(ignore: true)
  @override
  _$LoginUserCopyWith<_LoginUser> get copyWith =>
      __$LoginUserCopyWithImpl<_LoginUser>(this, _$identity);
}

abstract class _LoginUser extends LoginUser {
  const factory _LoginUser({required User user, required bool emailVerified}) =
      _$_LoginUser;
  const _LoginUser._() : super._();

  @override
  User get user => throw _privateConstructorUsedError;
  @override
  bool get emailVerified => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$LoginUserCopyWith<_LoginUser> get copyWith =>
      throw _privateConstructorUsedError;
}
