// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'my_profile_view_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$MyProfileViewDataTearOff {
  const _$MyProfileViewDataTearOff();

  _MyProfileViewData call(
      {required String id,
      required String name,
      String? imageUrl,
      required String introduction,
      required bool emailVerified}) {
    return _MyProfileViewData(
      id: id,
      name: name,
      imageUrl: imageUrl,
      introduction: introduction,
      emailVerified: emailVerified,
    );
  }
}

/// @nodoc
const $MyProfileViewData = _$MyProfileViewDataTearOff();

/// @nodoc
mixin _$MyProfileViewData {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String get introduction => throw _privateConstructorUsedError;
  bool get emailVerified => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MyProfileViewDataCopyWith<MyProfileViewData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MyProfileViewDataCopyWith<$Res> {
  factory $MyProfileViewDataCopyWith(
          MyProfileViewData value, $Res Function(MyProfileViewData) then) =
      _$MyProfileViewDataCopyWithImpl<$Res>;
  $Res call(
      {String id,
      String name,
      String? imageUrl,
      String introduction,
      bool emailVerified});
}

/// @nodoc
class _$MyProfileViewDataCopyWithImpl<$Res>
    implements $MyProfileViewDataCopyWith<$Res> {
  _$MyProfileViewDataCopyWithImpl(this._value, this._then);

  final MyProfileViewData _value;
  // ignore: unused_field
  final $Res Function(MyProfileViewData) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? imageUrl = freezed,
    Object? introduction = freezed,
    Object? emailVerified = freezed,
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
      emailVerified: emailVerified == freezed
          ? _value.emailVerified
          : emailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$MyProfileViewDataCopyWith<$Res>
    implements $MyProfileViewDataCopyWith<$Res> {
  factory _$MyProfileViewDataCopyWith(
          _MyProfileViewData value, $Res Function(_MyProfileViewData) then) =
      __$MyProfileViewDataCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      String name,
      String? imageUrl,
      String introduction,
      bool emailVerified});
}

/// @nodoc
class __$MyProfileViewDataCopyWithImpl<$Res>
    extends _$MyProfileViewDataCopyWithImpl<$Res>
    implements _$MyProfileViewDataCopyWith<$Res> {
  __$MyProfileViewDataCopyWithImpl(
      _MyProfileViewData _value, $Res Function(_MyProfileViewData) _then)
      : super(_value, (v) => _then(v as _MyProfileViewData));

  @override
  _MyProfileViewData get _value => super._value as _MyProfileViewData;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? imageUrl = freezed,
    Object? introduction = freezed,
    Object? emailVerified = freezed,
  }) {
    return _then(_MyProfileViewData(
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
      emailVerified: emailVerified == freezed
          ? _value.emailVerified
          : emailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_MyProfileViewData implements _MyProfileViewData {
  const _$_MyProfileViewData(
      {required this.id,
      required this.name,
      this.imageUrl,
      required this.introduction,
      required this.emailVerified});

  @override
  final String id;
  @override
  final String name;
  @override
  final String? imageUrl;
  @override
  final String introduction;
  @override
  final bool emailVerified;

  @override
  String toString() {
    return 'MyProfileViewData(id: $id, name: $name, imageUrl: $imageUrl, introduction: $introduction, emailVerified: $emailVerified)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _MyProfileViewData &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.imageUrl, imageUrl) ||
                const DeepCollectionEquality()
                    .equals(other.imageUrl, imageUrl)) &&
            (identical(other.introduction, introduction) ||
                const DeepCollectionEquality()
                    .equals(other.introduction, introduction)) &&
            (identical(other.emailVerified, emailVerified) ||
                const DeepCollectionEquality()
                    .equals(other.emailVerified, emailVerified)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(imageUrl) ^
      const DeepCollectionEquality().hash(introduction) ^
      const DeepCollectionEquality().hash(emailVerified);

  @JsonKey(ignore: true)
  @override
  _$MyProfileViewDataCopyWith<_MyProfileViewData> get copyWith =>
      __$MyProfileViewDataCopyWithImpl<_MyProfileViewData>(this, _$identity);
}

abstract class _MyProfileViewData implements MyProfileViewData {
  const factory _MyProfileViewData(
      {required String id,
      required String name,
      String? imageUrl,
      required String introduction,
      required bool emailVerified}) = _$_MyProfileViewData;

  @override
  String get id => throw _privateConstructorUsedError;
  @override
  String get name => throw _privateConstructorUsedError;
  @override
  String? get imageUrl => throw _privateConstructorUsedError;
  @override
  String get introduction => throw _privateConstructorUsedError;
  @override
  bool get emailVerified => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$MyProfileViewDataCopyWith<_MyProfileViewData> get copyWith =>
      throw _privateConstructorUsedError;
}
