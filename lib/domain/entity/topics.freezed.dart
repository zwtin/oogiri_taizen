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

  _Topics call({required List<Topic> list}) {
    return _Topics(
      list: list,
    );
  }
}

/// @nodoc
const $Topics = _$TopicsTearOff();

/// @nodoc
mixin _$Topics {
  List<Topic> get list => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TopicsCopyWith<Topics> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopicsCopyWith<$Res> {
  factory $TopicsCopyWith(Topics value, $Res Function(Topics) then) =
      _$TopicsCopyWithImpl<$Res>;
  $Res call({List<Topic> list});
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
  }) {
    return _then(_value.copyWith(
      list: list == freezed
          ? _value.list
          : list // ignore: cast_nullable_to_non_nullable
              as List<Topic>,
    ));
  }
}

/// @nodoc
abstract class _$TopicsCopyWith<$Res> implements $TopicsCopyWith<$Res> {
  factory _$TopicsCopyWith(_Topics value, $Res Function(_Topics) then) =
      __$TopicsCopyWithImpl<$Res>;
  @override
  $Res call({List<Topic> list});
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
  }) {
    return _then(_Topics(
      list: list == freezed
          ? _value.list
          : list // ignore: cast_nullable_to_non_nullable
              as List<Topic>,
    ));
  }
}

/// @nodoc

class _$_Topics extends _Topics {
  const _$_Topics({required this.list}) : super._();

  @override
  final List<Topic> list;

  @override
  String toString() {
    return 'Topics(list: $list)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Topics &&
            (identical(other.list, list) ||
                const DeepCollectionEquality().equals(other.list, list)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(list);

  @JsonKey(ignore: true)
  @override
  _$TopicsCopyWith<_Topics> get copyWith =>
      __$TopicsCopyWithImpl<_Topics>(this, _$identity);
}

abstract class _Topics extends Topics {
  const factory _Topics({required List<Topic> list}) = _$_Topics;
  const _Topics._() : super._();

  @override
  List<Topic> get list => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$TopicsCopyWith<_Topics> get copyWith => throw _privateConstructorUsedError;
}
