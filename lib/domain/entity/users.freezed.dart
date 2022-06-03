// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'users.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$UsersTearOff {
  const _$UsersTearOff();

  _Users call({required List<User> list}) {
    return _Users(
      list: list,
    );
  }
}

/// @nodoc
const $Users = _$UsersTearOff();

/// @nodoc
mixin _$Users {
  List<User> get list => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UsersCopyWith<Users> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UsersCopyWith<$Res> {
  factory $UsersCopyWith(Users value, $Res Function(Users) then) =
      _$UsersCopyWithImpl<$Res>;
  $Res call({List<User> list});
}

/// @nodoc
class _$UsersCopyWithImpl<$Res> implements $UsersCopyWith<$Res> {
  _$UsersCopyWithImpl(this._value, this._then);

  final Users _value;
  // ignore: unused_field
  final $Res Function(Users) _then;

  @override
  $Res call({
    Object? list = freezed,
  }) {
    return _then(_value.copyWith(
      list: list == freezed
          ? _value.list
          : list // ignore: cast_nullable_to_non_nullable
              as List<User>,
    ));
  }
}

/// @nodoc
abstract class _$UsersCopyWith<$Res> implements $UsersCopyWith<$Res> {
  factory _$UsersCopyWith(_Users value, $Res Function(_Users) then) =
      __$UsersCopyWithImpl<$Res>;
  @override
  $Res call({List<User> list});
}

/// @nodoc
class __$UsersCopyWithImpl<$Res> extends _$UsersCopyWithImpl<$Res>
    implements _$UsersCopyWith<$Res> {
  __$UsersCopyWithImpl(_Users _value, $Res Function(_Users) _then)
      : super(_value, (v) => _then(v as _Users));

  @override
  _Users get _value => super._value as _Users;

  @override
  $Res call({
    Object? list = freezed,
  }) {
    return _then(_Users(
      list: list == freezed
          ? _value.list
          : list // ignore: cast_nullable_to_non_nullable
              as List<User>,
    ));
  }
}

/// @nodoc

class _$_Users extends _Users {
  const _$_Users({required this.list}) : super._();

  @override
  final List<User> list;

  @override
  String toString() {
    return 'Users(list: $list)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Users &&
            (identical(other.list, list) ||
                const DeepCollectionEquality().equals(other.list, list)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(list);

  @JsonKey(ignore: true)
  @override
  _$UsersCopyWith<_Users> get copyWith =>
      __$UsersCopyWithImpl<_Users>(this, _$identity);
}

abstract class _Users extends Users {
  const factory _Users({required List<User> list}) = _$_Users;
  const _Users._() : super._();

  @override
  List<User> get list => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$UsersCopyWith<_Users> get copyWith => throw _privateConstructorUsedError;
}
