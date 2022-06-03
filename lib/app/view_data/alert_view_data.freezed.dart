// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'alert_view_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$AlertViewDataTearOff {
  const _$AlertViewDataTearOff();

  _AlertViewData call(
      {required String title,
      required String message,
      String? okButtonTitle,
      void Function()? okButtonAction,
      String? cancelButtonTitle,
      void Function()? cancelButtonAction}) {
    return _AlertViewData(
      title: title,
      message: message,
      okButtonTitle: okButtonTitle,
      okButtonAction: okButtonAction,
      cancelButtonTitle: cancelButtonTitle,
      cancelButtonAction: cancelButtonAction,
    );
  }
}

/// @nodoc
const $AlertViewData = _$AlertViewDataTearOff();

/// @nodoc
mixin _$AlertViewData {
  String get title => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String? get okButtonTitle => throw _privateConstructorUsedError;
  void Function()? get okButtonAction => throw _privateConstructorUsedError;
  String? get cancelButtonTitle => throw _privateConstructorUsedError;
  void Function()? get cancelButtonAction => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AlertViewDataCopyWith<AlertViewData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlertViewDataCopyWith<$Res> {
  factory $AlertViewDataCopyWith(
          AlertViewData value, $Res Function(AlertViewData) then) =
      _$AlertViewDataCopyWithImpl<$Res>;
  $Res call(
      {String title,
      String message,
      String? okButtonTitle,
      void Function()? okButtonAction,
      String? cancelButtonTitle,
      void Function()? cancelButtonAction});
}

/// @nodoc
class _$AlertViewDataCopyWithImpl<$Res>
    implements $AlertViewDataCopyWith<$Res> {
  _$AlertViewDataCopyWithImpl(this._value, this._then);

  final AlertViewData _value;
  // ignore: unused_field
  final $Res Function(AlertViewData) _then;

  @override
  $Res call({
    Object? title = freezed,
    Object? message = freezed,
    Object? okButtonTitle = freezed,
    Object? okButtonAction = freezed,
    Object? cancelButtonTitle = freezed,
    Object? cancelButtonAction = freezed,
  }) {
    return _then(_value.copyWith(
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      okButtonTitle: okButtonTitle == freezed
          ? _value.okButtonTitle
          : okButtonTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      okButtonAction: okButtonAction == freezed
          ? _value.okButtonAction
          : okButtonAction // ignore: cast_nullable_to_non_nullable
              as void Function()?,
      cancelButtonTitle: cancelButtonTitle == freezed
          ? _value.cancelButtonTitle
          : cancelButtonTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      cancelButtonAction: cancelButtonAction == freezed
          ? _value.cancelButtonAction
          : cancelButtonAction // ignore: cast_nullable_to_non_nullable
              as void Function()?,
    ));
  }
}

/// @nodoc
abstract class _$AlertViewDataCopyWith<$Res>
    implements $AlertViewDataCopyWith<$Res> {
  factory _$AlertViewDataCopyWith(
          _AlertViewData value, $Res Function(_AlertViewData) then) =
      __$AlertViewDataCopyWithImpl<$Res>;
  @override
  $Res call(
      {String title,
      String message,
      String? okButtonTitle,
      void Function()? okButtonAction,
      String? cancelButtonTitle,
      void Function()? cancelButtonAction});
}

/// @nodoc
class __$AlertViewDataCopyWithImpl<$Res>
    extends _$AlertViewDataCopyWithImpl<$Res>
    implements _$AlertViewDataCopyWith<$Res> {
  __$AlertViewDataCopyWithImpl(
      _AlertViewData _value, $Res Function(_AlertViewData) _then)
      : super(_value, (v) => _then(v as _AlertViewData));

  @override
  _AlertViewData get _value => super._value as _AlertViewData;

  @override
  $Res call({
    Object? title = freezed,
    Object? message = freezed,
    Object? okButtonTitle = freezed,
    Object? okButtonAction = freezed,
    Object? cancelButtonTitle = freezed,
    Object? cancelButtonAction = freezed,
  }) {
    return _then(_AlertViewData(
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      okButtonTitle: okButtonTitle == freezed
          ? _value.okButtonTitle
          : okButtonTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      okButtonAction: okButtonAction == freezed
          ? _value.okButtonAction
          : okButtonAction // ignore: cast_nullable_to_non_nullable
              as void Function()?,
      cancelButtonTitle: cancelButtonTitle == freezed
          ? _value.cancelButtonTitle
          : cancelButtonTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      cancelButtonAction: cancelButtonAction == freezed
          ? _value.cancelButtonAction
          : cancelButtonAction // ignore: cast_nullable_to_non_nullable
              as void Function()?,
    ));
  }
}

/// @nodoc

class _$_AlertViewData implements _AlertViewData {
  const _$_AlertViewData(
      {required this.title,
      required this.message,
      this.okButtonTitle,
      this.okButtonAction,
      this.cancelButtonTitle,
      this.cancelButtonAction});

  @override
  final String title;
  @override
  final String message;
  @override
  final String? okButtonTitle;
  @override
  final void Function()? okButtonAction;
  @override
  final String? cancelButtonTitle;
  @override
  final void Function()? cancelButtonAction;

  @override
  String toString() {
    return 'AlertViewData(title: $title, message: $message, okButtonTitle: $okButtonTitle, okButtonAction: $okButtonAction, cancelButtonTitle: $cancelButtonTitle, cancelButtonAction: $cancelButtonAction)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _AlertViewData &&
            (identical(other.title, title) ||
                const DeepCollectionEquality().equals(other.title, title)) &&
            (identical(other.message, message) ||
                const DeepCollectionEquality()
                    .equals(other.message, message)) &&
            (identical(other.okButtonTitle, okButtonTitle) ||
                const DeepCollectionEquality()
                    .equals(other.okButtonTitle, okButtonTitle)) &&
            (identical(other.okButtonAction, okButtonAction) ||
                const DeepCollectionEquality()
                    .equals(other.okButtonAction, okButtonAction)) &&
            (identical(other.cancelButtonTitle, cancelButtonTitle) ||
                const DeepCollectionEquality()
                    .equals(other.cancelButtonTitle, cancelButtonTitle)) &&
            (identical(other.cancelButtonAction, cancelButtonAction) ||
                const DeepCollectionEquality()
                    .equals(other.cancelButtonAction, cancelButtonAction)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(title) ^
      const DeepCollectionEquality().hash(message) ^
      const DeepCollectionEquality().hash(okButtonTitle) ^
      const DeepCollectionEquality().hash(okButtonAction) ^
      const DeepCollectionEquality().hash(cancelButtonTitle) ^
      const DeepCollectionEquality().hash(cancelButtonAction);

  @JsonKey(ignore: true)
  @override
  _$AlertViewDataCopyWith<_AlertViewData> get copyWith =>
      __$AlertViewDataCopyWithImpl<_AlertViewData>(this, _$identity);
}

abstract class _AlertViewData implements AlertViewData {
  const factory _AlertViewData(
      {required String title,
      required String message,
      String? okButtonTitle,
      void Function()? okButtonAction,
      String? cancelButtonTitle,
      void Function()? cancelButtonAction}) = _$_AlertViewData;

  @override
  String get title => throw _privateConstructorUsedError;
  @override
  String get message => throw _privateConstructorUsedError;
  @override
  String? get okButtonTitle => throw _privateConstructorUsedError;
  @override
  void Function()? get okButtonAction => throw _privateConstructorUsedError;
  @override
  String? get cancelButtonTitle => throw _privateConstructorUsedError;
  @override
  void Function()? get cancelButtonAction => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$AlertViewDataCopyWith<_AlertViewData> get copyWith =>
      throw _privateConstructorUsedError;
}
