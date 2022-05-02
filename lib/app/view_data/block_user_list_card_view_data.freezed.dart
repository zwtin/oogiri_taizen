// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'block_user_list_card_view_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$BlockUserListCardViewDataTearOff {
  const _$BlockUserListCardViewDataTearOff();

  _BlockUserListCardViewData call(
      {required String id, String? userImageUrl, required String userName}) {
    return _BlockUserListCardViewData(
      id: id,
      userImageUrl: userImageUrl,
      userName: userName,
    );
  }
}

/// @nodoc
const $BlockUserListCardViewData = _$BlockUserListCardViewDataTearOff();

/// @nodoc
mixin _$BlockUserListCardViewData {
  String get id => throw _privateConstructorUsedError;
  String? get userImageUrl => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BlockUserListCardViewDataCopyWith<BlockUserListCardViewData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BlockUserListCardViewDataCopyWith<$Res> {
  factory $BlockUserListCardViewDataCopyWith(BlockUserListCardViewData value,
          $Res Function(BlockUserListCardViewData) then) =
      _$BlockUserListCardViewDataCopyWithImpl<$Res>;
  $Res call({String id, String? userImageUrl, String userName});
}

/// @nodoc
class _$BlockUserListCardViewDataCopyWithImpl<$Res>
    implements $BlockUserListCardViewDataCopyWith<$Res> {
  _$BlockUserListCardViewDataCopyWithImpl(this._value, this._then);

  final BlockUserListCardViewData _value;
  // ignore: unused_field
  final $Res Function(BlockUserListCardViewData) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? userImageUrl = freezed,
    Object? userName = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userImageUrl: userImageUrl == freezed
          ? _value.userImageUrl
          : userImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      userName: userName == freezed
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$BlockUserListCardViewDataCopyWith<$Res>
    implements $BlockUserListCardViewDataCopyWith<$Res> {
  factory _$BlockUserListCardViewDataCopyWith(_BlockUserListCardViewData value,
          $Res Function(_BlockUserListCardViewData) then) =
      __$BlockUserListCardViewDataCopyWithImpl<$Res>;
  @override
  $Res call({String id, String? userImageUrl, String userName});
}

/// @nodoc
class __$BlockUserListCardViewDataCopyWithImpl<$Res>
    extends _$BlockUserListCardViewDataCopyWithImpl<$Res>
    implements _$BlockUserListCardViewDataCopyWith<$Res> {
  __$BlockUserListCardViewDataCopyWithImpl(_BlockUserListCardViewData _value,
      $Res Function(_BlockUserListCardViewData) _then)
      : super(_value, (v) => _then(v as _BlockUserListCardViewData));

  @override
  _BlockUserListCardViewData get _value =>
      super._value as _BlockUserListCardViewData;

  @override
  $Res call({
    Object? id = freezed,
    Object? userImageUrl = freezed,
    Object? userName = freezed,
  }) {
    return _then(_BlockUserListCardViewData(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userImageUrl: userImageUrl == freezed
          ? _value.userImageUrl
          : userImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      userName: userName == freezed
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_BlockUserListCardViewData implements _BlockUserListCardViewData {
  const _$_BlockUserListCardViewData(
      {required this.id, this.userImageUrl, required this.userName});

  @override
  final String id;
  @override
  final String? userImageUrl;
  @override
  final String userName;

  @override
  String toString() {
    return 'BlockUserListCardViewData(id: $id, userImageUrl: $userImageUrl, userName: $userName)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _BlockUserListCardViewData &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.userImageUrl, userImageUrl) ||
                const DeepCollectionEquality()
                    .equals(other.userImageUrl, userImageUrl)) &&
            (identical(other.userName, userName) ||
                const DeepCollectionEquality()
                    .equals(other.userName, userName)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(userImageUrl) ^
      const DeepCollectionEquality().hash(userName);

  @JsonKey(ignore: true)
  @override
  _$BlockUserListCardViewDataCopyWith<_BlockUserListCardViewData>
      get copyWith =>
          __$BlockUserListCardViewDataCopyWithImpl<_BlockUserListCardViewData>(
              this, _$identity);
}

abstract class _BlockUserListCardViewData implements BlockUserListCardViewData {
  const factory _BlockUserListCardViewData(
      {required String id,
      String? userImageUrl,
      required String userName}) = _$_BlockUserListCardViewData;

  @override
  String get id => throw _privateConstructorUsedError;
  @override
  String? get userImageUrl => throw _privateConstructorUsedError;
  @override
  String get userName => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$BlockUserListCardViewDataCopyWith<_BlockUserListCardViewData>
      get copyWith => throw _privateConstructorUsedError;
}
