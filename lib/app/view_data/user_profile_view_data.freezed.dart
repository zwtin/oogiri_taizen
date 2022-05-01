// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'user_profile_view_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$UserProfileViewDataTearOff {
  const _$UserProfileViewDataTearOff();

  _UserProfileViewData call(
      {required String id,
      required String name,
      String? imageUrl,
      required String introduction}) {
    return _UserProfileViewData(
      id: id,
      name: name,
      imageUrl: imageUrl,
      introduction: introduction,
    );
  }
}

/// @nodoc
const $UserProfileViewData = _$UserProfileViewDataTearOff();

/// @nodoc
mixin _$UserProfileViewData {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String get introduction => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserProfileViewDataCopyWith<UserProfileViewData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileViewDataCopyWith<$Res> {
  factory $UserProfileViewDataCopyWith(
          UserProfileViewData value, $Res Function(UserProfileViewData) then) =
      _$UserProfileViewDataCopyWithImpl<$Res>;
  $Res call({String id, String name, String? imageUrl, String introduction});
}

/// @nodoc
class _$UserProfileViewDataCopyWithImpl<$Res>
    implements $UserProfileViewDataCopyWith<$Res> {
  _$UserProfileViewDataCopyWithImpl(this._value, this._then);

  final UserProfileViewData _value;
  // ignore: unused_field
  final $Res Function(UserProfileViewData) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? imageUrl = freezed,
    Object? introduction = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: imageUrl == freezed
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      introduction: introduction == freezed
          ? _value.introduction
          : introduction // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$UserProfileViewDataCopyWith<$Res>
    implements $UserProfileViewDataCopyWith<$Res> {
  factory _$UserProfileViewDataCopyWith(_UserProfileViewData value,
          $Res Function(_UserProfileViewData) then) =
      __$UserProfileViewDataCopyWithImpl<$Res>;
  @override
  $Res call({String id, String name, String? imageUrl, String introduction});
}

/// @nodoc
class __$UserProfileViewDataCopyWithImpl<$Res>
    extends _$UserProfileViewDataCopyWithImpl<$Res>
    implements _$UserProfileViewDataCopyWith<$Res> {
  __$UserProfileViewDataCopyWithImpl(
      _UserProfileViewData _value, $Res Function(_UserProfileViewData) _then)
      : super(_value, (v) => _then(v as _UserProfileViewData));

  @override
  _UserProfileViewData get _value => super._value as _UserProfileViewData;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? imageUrl = freezed,
    Object? introduction = freezed,
  }) {
    return _then(_UserProfileViewData(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: imageUrl == freezed
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      introduction: introduction == freezed
          ? _value.introduction
          : introduction // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_UserProfileViewData implements _UserProfileViewData {
  const _$_UserProfileViewData(
      {required this.id,
      required this.name,
      this.imageUrl,
      required this.introduction});

  @override
  final String id;
  @override
  final String name;
  @override
  final String? imageUrl;
  @override
  final String introduction;

  @override
  String toString() {
    return 'UserProfileViewData(id: $id, name: $name, imageUrl: $imageUrl, introduction: $introduction)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _UserProfileViewData &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.imageUrl, imageUrl) ||
                const DeepCollectionEquality()
                    .equals(other.imageUrl, imageUrl)) &&
            (identical(other.introduction, introduction) ||
                const DeepCollectionEquality()
                    .equals(other.introduction, introduction)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(imageUrl) ^
      const DeepCollectionEquality().hash(introduction);

  @JsonKey(ignore: true)
  @override
  _$UserProfileViewDataCopyWith<_UserProfileViewData> get copyWith =>
      __$UserProfileViewDataCopyWithImpl<_UserProfileViewData>(
          this, _$identity);
}

abstract class _UserProfileViewData implements UserProfileViewData {
  const factory _UserProfileViewData(
      {required String id,
      required String name,
      String? imageUrl,
      required String introduction}) = _$_UserProfileViewData;

  @override
  String get id => throw _privateConstructorUsedError;
  @override
  String get name => throw _privateConstructorUsedError;
  @override
  String? get imageUrl => throw _privateConstructorUsedError;
  @override
  String get introduction => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$UserProfileViewDataCopyWith<_UserProfileViewData> get copyWith =>
      throw _privateConstructorUsedError;
}
