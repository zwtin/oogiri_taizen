// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'topics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$TopicsTearOff {
  const _$TopicsTearOff();

  _Topics call({required List<Topic> list, required bool hasNext}) {
    return _Topics(
      list: list,
      hasNext: hasNext,
    );
  }
}

/// @nodoc
const $Topics = _$TopicsTearOff();

/// @nodoc
mixin _$Topics {
  List<Topic> get list => throw _privateConstructorUsedError;
  bool get hasNext => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TopicsCopyWith<Topics> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopicsCopyWith<$Res> {
  factory $TopicsCopyWith(Topics value, $Res Function(Topics) then) =
      _$TopicsCopyWithImpl<$Res>;
  $Res call({List<Topic> list, bool hasNext});
}

/// @nodoc
class _$TopicsCopyWithImpl<$Res> implements $TopicsCopyWith<$Res> {
  _$TopicsCopyWithImpl(this._value, this._then);

  final Topics _value;
  // ignore: unused_field
  final $Res Function(Topics) _then;

  @override
  $Res call({
    Object? list = freezed,
    Object? hasNext = freezed,
  }) {
    return _then(_value.copyWith(
      list: list == freezed
          ? _value.list
          : list // ignore: cast_nullable_to_non_nullable
              as List<Topic>,
      hasNext: hasNext == freezed
          ? _value.hasNext
          : hasNext // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$TopicsCopyWith<$Res> implements $TopicsCopyWith<$Res> {
  factory _$TopicsCopyWith(_Topics value, $Res Function(_Topics) then) =
      __$TopicsCopyWithImpl<$Res>;
  @override
  $Res call({List<Topic> list, bool hasNext});
}

/// @nodoc
class __$TopicsCopyWithImpl<$Res> extends _$TopicsCopyWithImpl<$Res>
    implements _$TopicsCopyWith<$Res> {
  __$TopicsCopyWithImpl(_Topics _value, $Res Function(_Topics) _then)
      : super(_value, (v) => _then(v as _Topics));

  @override
  _Topics get _value => super._value as _Topics;

  @override
  $Res call({
    Object? list = freezed,
    Object? hasNext = freezed,
  }) {
    return _then(_Topics(
      list: list == freezed
          ? _value.list
          : list // ignore: cast_nullable_to_non_nullable
              as List<Topic>,
      hasNext: hasNext == freezed
          ? _value.hasNext
          : hasNext // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_Topics implements _Topics {
  const _$_Topics({required this.list, required this.hasNext});

  @override
  final List<Topic> list;
  @override
  final bool hasNext;

  @override
  String toString() {
    return 'Topics(list: $list, hasNext: $hasNext)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Topics &&
            (identical(other.list, list) ||
                const DeepCollectionEquality().equals(other.list, list)) &&
            (identical(other.hasNext, hasNext) ||
                const DeepCollectionEquality().equals(other.hasNext, hasNext)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(list) ^
      const DeepCollectionEquality().hash(hasNext);

  @JsonKey(ignore: true)
  @override
  _$TopicsCopyWith<_Topics> get copyWith =>
      __$TopicsCopyWithImpl<_Topics>(this, _$identity);
}

abstract class _Topics implements Topics {
  const factory _Topics({required List<Topic> list, required bool hasNext}) =
      _$_Topics;

  @override
  List<Topic> get list => throw _privateConstructorUsedError;
  @override
  bool get hasNext => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$TopicsCopyWith<_Topics> get copyWith => throw _privateConstructorUsedError;
}
