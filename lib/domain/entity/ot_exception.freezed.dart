// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'ot_exception.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$OTExceptionTearOff {
  const _$OTExceptionTearOff();

  _OTException call({required String title, required String text}) {
    return _OTException(
      title: title,
      text: text,
    );
  }
}

/// @nodoc
const $OTException = _$OTExceptionTearOff();

/// @nodoc
mixin _$OTException {
  String get title => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OTExceptionCopyWith<OTException> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OTExceptionCopyWith<$Res> {
  factory $OTExceptionCopyWith(
          OTException value, $Res Function(OTException) then) =
      _$OTExceptionCopyWithImpl<$Res>;
  $Res call({String title, String text});
}

/// @nodoc
class _$OTExceptionCopyWithImpl<$Res> implements $OTExceptionCopyWith<$Res> {
  _$OTExceptionCopyWithImpl(this._value, this._then);

  final OTException _value;
  // ignore: unused_field
  final $Res Function(OTException) _then;

  @override
  $Res call({
    Object? title = freezed,
    Object? text = freezed,
  }) {
    return _then(_value.copyWith(
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      text: text == freezed
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$OTExceptionCopyWith<$Res>
    implements $OTExceptionCopyWith<$Res> {
  factory _$OTExceptionCopyWith(
          _OTException value, $Res Function(_OTException) then) =
      __$OTExceptionCopyWithImpl<$Res>;
  @override
  $Res call({String title, String text});
}

/// @nodoc
class __$OTExceptionCopyWithImpl<$Res> extends _$OTExceptionCopyWithImpl<$Res>
    implements _$OTExceptionCopyWith<$Res> {
  __$OTExceptionCopyWithImpl(
      _OTException _value, $Res Function(_OTException) _then)
      : super(_value, (v) => _then(v as _OTException));

  @override
  _OTException get _value => super._value as _OTException;

  @override
  $Res call({
    Object? title = freezed,
    Object? text = freezed,
  }) {
    return _then(_OTException(
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      text: text == freezed
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_OTException extends _OTException {
  const _$_OTException({required this.title, required this.text}) : super._();

  @override
  final String title;
  @override
  final String text;

  @override
  String toString() {
    return 'OTException(title: $title, text: $text)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _OTException &&
            (identical(other.title, title) ||
                const DeepCollectionEquality().equals(other.title, title)) &&
            (identical(other.text, text) ||
                const DeepCollectionEquality().equals(other.text, text)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(title) ^
      const DeepCollectionEquality().hash(text);

  @JsonKey(ignore: true)
  @override
  _$OTExceptionCopyWith<_OTException> get copyWith =>
      __$OTExceptionCopyWithImpl<_OTException>(this, _$identity);
}

abstract class _OTException extends OTException {
  const factory _OTException({required String title, required String text}) =
      _$_OTException;
  const _OTException._() : super._();

  @override
  String get title => throw _privateConstructorUsedError;
  @override
  String get text => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$OTExceptionCopyWith<_OTException> get copyWith =>
      throw _privateConstructorUsedError;
}
