// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'answers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$AnswersTearOff {
  const _$AnswersTearOff();

  _Answers call({required List<Answer> list}) {
    return _Answers(
      list: list,
    );
  }
}

/// @nodoc
const $Answers = _$AnswersTearOff();

/// @nodoc
mixin _$Answers {
  List<Answer> get list => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AnswersCopyWith<Answers> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnswersCopyWith<$Res> {
  factory $AnswersCopyWith(Answers value, $Res Function(Answers) then) =
      _$AnswersCopyWithImpl<$Res>;
  $Res call({List<Answer> list});
}

/// @nodoc
class _$AnswersCopyWithImpl<$Res> implements $AnswersCopyWith<$Res> {
  _$AnswersCopyWithImpl(this._value, this._then);

  final Answers _value;
  // ignore: unused_field
  final $Res Function(Answers) _then;

  @override
  $Res call({
    Object? list = freezed,
  }) {
    return _then(_value.copyWith(
      list: list == freezed
          ? _value.list
          : list // ignore: cast_nullable_to_non_nullable
              as List<Answer>,
    ));
  }
}

/// @nodoc
abstract class _$AnswersCopyWith<$Res> implements $AnswersCopyWith<$Res> {
  factory _$AnswersCopyWith(_Answers value, $Res Function(_Answers) then) =
      __$AnswersCopyWithImpl<$Res>;
  @override
  $Res call({List<Answer> list});
}

/// @nodoc
class __$AnswersCopyWithImpl<$Res> extends _$AnswersCopyWithImpl<$Res>
    implements _$AnswersCopyWith<$Res> {
  __$AnswersCopyWithImpl(_Answers _value, $Res Function(_Answers) _then)
      : super(_value, (v) => _then(v as _Answers));

  @override
  _Answers get _value => super._value as _Answers;

  @override
  $Res call({
    Object? list = freezed,
  }) {
    return _then(_Answers(
      list: list == freezed
          ? _value.list
          : list // ignore: cast_nullable_to_non_nullable
              as List<Answer>,
    ));
  }
}

/// @nodoc

class _$_Answers extends _Answers {
  const _$_Answers({required this.list}) : super._();

  @override
  final List<Answer> list;

  @override
  String toString() {
    return 'Answers(list: $list)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Answers &&
            (identical(other.list, list) ||
                const DeepCollectionEquality().equals(other.list, list)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(list);

  @JsonKey(ignore: true)
  @override
  _$AnswersCopyWith<_Answers> get copyWith =>
      __$AnswersCopyWithImpl<_Answers>(this, _$identity);
}

abstract class _Answers extends Answers {
  const factory _Answers({required List<Answer> list}) = _$_Answers;
  const _Answers._() : super._();

  @override
  List<Answer> get list => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$AnswersCopyWith<_Answers> get copyWith =>
      throw _privateConstructorUsedError;
}
