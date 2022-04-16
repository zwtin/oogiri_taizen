// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'ot_error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$OTErrorTearOff {
  const _$OTErrorTearOff();

  _OTError call({required String title, required String text}) {
    return _OTError(
      title: title,
      text: text,
    );
  }
}

/// @nodoc
const $OTError = _$OTErrorTearOff();

/// @nodoc
mixin _$OTError {
  String get title => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OTErrorCopyWith<OTError> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OTErrorCopyWith<$Res> {
  factory $OTErrorCopyWith(OTError value, $Res Function(OTError) then) =
      _$OTErrorCopyWithImpl<$Res>;
  $Res call({String title, String text});
}

/// @nodoc
class _$OTErrorCopyWithImpl<$Res> implements $OTErrorCopyWith<$Res> {
  _$OTErrorCopyWithImpl(this._value, this._then);

  final OTError _value;
  // ignore: unused_field
  final $Res Function(OTError) _then;

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
abstract class _$OTErrorCopyWith<$Res> implements $OTErrorCopyWith<$Res> {
  factory _$OTErrorCopyWith(_OTError value, $Res Function(_OTError) then) =
      __$OTErrorCopyWithImpl<$Res>;
  @override
  $Res call({String title, String text});
}

/// @nodoc
class __$OTErrorCopyWithImpl<$Res> extends _$OTErrorCopyWithImpl<$Res>
    implements _$OTErrorCopyWith<$Res> {
  __$OTErrorCopyWithImpl(_OTError _value, $Res Function(_OTError) _then)
      : super(_value, (v) => _then(v as _OTError));

  @override
  _OTError get _value => super._value as _OTError;

  @override
  $Res call({
    Object? title = freezed,
    Object? text = freezed,
  }) {
    return _then(_OTError(
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

class _$_OTError extends _OTError {
  const _$_OTError({required this.title, required this.text}) : super._();

  @override
  final String title;
  @override
  final String text;

  @override
  String toString() {
    return 'OTError(title: $title, text: $text)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _OTError &&
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
  _$OTErrorCopyWith<_OTError> get copyWith =>
      __$OTErrorCopyWithImpl<_OTError>(this, _$identity);
}

abstract class _OTError extends OTError {
  const factory _OTError({required String title, required String text}) =
      _$_OTError;
  const _OTError._() : super._();

  @override
  String get title => throw _privateConstructorUsedError;
  @override
  String get text => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$OTErrorCopyWith<_OTError> get copyWith =>
      throw _privateConstructorUsedError;
}
