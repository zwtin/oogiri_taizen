// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'push_notification_setting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$PushNotificationSettingTearOff {
  const _$PushNotificationSettingTearOff();

  _PushNotificationSetting call(
      {required bool whenLiked, required bool whenFavored}) {
    return _PushNotificationSetting(
      whenLiked: whenLiked,
      whenFavored: whenFavored,
    );
  }
}

/// @nodoc
const $PushNotificationSetting = _$PushNotificationSettingTearOff();

/// @nodoc
mixin _$PushNotificationSetting {
  bool get whenLiked => throw _privateConstructorUsedError;
  bool get whenFavored => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PushNotificationSettingCopyWith<PushNotificationSetting> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PushNotificationSettingCopyWith<$Res> {
  factory $PushNotificationSettingCopyWith(PushNotificationSetting value,
          $Res Function(PushNotificationSetting) then) =
      _$PushNotificationSettingCopyWithImpl<$Res>;
  $Res call({bool whenLiked, bool whenFavored});
}

/// @nodoc
class _$PushNotificationSettingCopyWithImpl<$Res>
    implements $PushNotificationSettingCopyWith<$Res> {
  _$PushNotificationSettingCopyWithImpl(this._value, this._then);

  final PushNotificationSetting _value;
  // ignore: unused_field
  final $Res Function(PushNotificationSetting) _then;

  @override
  $Res call({
    Object? whenLiked = freezed,
    Object? whenFavored = freezed,
  }) {
    return _then(_value.copyWith(
      whenLiked: whenLiked == freezed
          ? _value.whenLiked
          : whenLiked // ignore: cast_nullable_to_non_nullable
              as bool,
      whenFavored: whenFavored == freezed
          ? _value.whenFavored
          : whenFavored // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$PushNotificationSettingCopyWith<$Res>
    implements $PushNotificationSettingCopyWith<$Res> {
  factory _$PushNotificationSettingCopyWith(_PushNotificationSetting value,
          $Res Function(_PushNotificationSetting) then) =
      __$PushNotificationSettingCopyWithImpl<$Res>;
  @override
  $Res call({bool whenLiked, bool whenFavored});
}

/// @nodoc
class __$PushNotificationSettingCopyWithImpl<$Res>
    extends _$PushNotificationSettingCopyWithImpl<$Res>
    implements _$PushNotificationSettingCopyWith<$Res> {
  __$PushNotificationSettingCopyWithImpl(_PushNotificationSetting _value,
      $Res Function(_PushNotificationSetting) _then)
      : super(_value, (v) => _then(v as _PushNotificationSetting));

  @override
  _PushNotificationSetting get _value =>
      super._value as _PushNotificationSetting;

  @override
  $Res call({
    Object? whenLiked = freezed,
    Object? whenFavored = freezed,
  }) {
    return _then(_PushNotificationSetting(
      whenLiked: whenLiked == freezed
          ? _value.whenLiked
          : whenLiked // ignore: cast_nullable_to_non_nullable
              as bool,
      whenFavored: whenFavored == freezed
          ? _value.whenFavored
          : whenFavored // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_PushNotificationSetting extends _PushNotificationSetting {
  const _$_PushNotificationSetting(
      {required this.whenLiked, required this.whenFavored})
      : super._();

  @override
  final bool whenLiked;
  @override
  final bool whenFavored;

  @override
  String toString() {
    return 'PushNotificationSetting(whenLiked: $whenLiked, whenFavored: $whenFavored)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _PushNotificationSetting &&
            (identical(other.whenLiked, whenLiked) ||
                const DeepCollectionEquality()
                    .equals(other.whenLiked, whenLiked)) &&
            (identical(other.whenFavored, whenFavored) ||
                const DeepCollectionEquality()
                    .equals(other.whenFavored, whenFavored)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(whenLiked) ^
      const DeepCollectionEquality().hash(whenFavored);

  @JsonKey(ignore: true)
  @override
  _$PushNotificationSettingCopyWith<_PushNotificationSetting> get copyWith =>
      __$PushNotificationSettingCopyWithImpl<_PushNotificationSetting>(
          this, _$identity);
}

abstract class _PushNotificationSetting extends PushNotificationSetting {
  const factory _PushNotificationSetting(
      {required bool whenLiked,
      required bool whenFavored}) = _$_PushNotificationSetting;
  const _PushNotificationSetting._() : super._();

  @override
  bool get whenLiked => throw _privateConstructorUsedError;
  @override
  bool get whenFavored => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$PushNotificationSettingCopyWith<_PushNotificationSetting> get copyWith =>
      throw _privateConstructorUsedError;
}
