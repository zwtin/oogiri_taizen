// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'answer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$AnswerTearOff {
  const _$AnswerTearOff();

  _Answer call(
      {required String id,
      required String text,
      required int viewedTime,
      required bool isLike,
      required int likedTime,
      required bool isFavor,
      required int favoredTime,
      required int point,
      required DateTime createdAt,
      required Topic topic,
      required User createdUser,
      required bool isOwn}) {
    return _Answer(
      id: id,
      text: text,
      viewedTime: viewedTime,
      isLike: isLike,
      likedTime: likedTime,
      isFavor: isFavor,
      favoredTime: favoredTime,
      point: point,
      createdAt: createdAt,
      topic: topic,
      createdUser: createdUser,
      isOwn: isOwn,
    );
  }
}

/// @nodoc
const $Answer = _$AnswerTearOff();

/// @nodoc
mixin _$Answer {
  String get id => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  int get viewedTime => throw _privateConstructorUsedError;
  bool get isLike => throw _privateConstructorUsedError;
  int get likedTime => throw _privateConstructorUsedError;
  bool get isFavor => throw _privateConstructorUsedError;
  int get favoredTime => throw _privateConstructorUsedError;
  int get point => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  Topic get topic => throw _privateConstructorUsedError;
  User get createdUser => throw _privateConstructorUsedError;
  bool get isOwn => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AnswerCopyWith<Answer> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnswerCopyWith<$Res> {
  factory $AnswerCopyWith(Answer value, $Res Function(Answer) then) =
      _$AnswerCopyWithImpl<$Res>;
  $Res call(
      {String id,
      String text,
      int viewedTime,
      bool isLike,
      int likedTime,
      bool isFavor,
      int favoredTime,
      int point,
      DateTime createdAt,
      Topic topic,
      User createdUser,
      bool isOwn});

  $TopicCopyWith<$Res> get topic;
  $UserCopyWith<$Res> get createdUser;
}

/// @nodoc
class _$AnswerCopyWithImpl<$Res> implements $AnswerCopyWith<$Res> {
  _$AnswerCopyWithImpl(this._value, this._then);

  final Answer _value;
  // ignore: unused_field
  final $Res Function(Answer) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? text = freezed,
    Object? viewedTime = freezed,
    Object? isLike = freezed,
    Object? likedTime = freezed,
    Object? isFavor = freezed,
    Object? favoredTime = freezed,
    Object? point = freezed,
    Object? createdAt = freezed,
    Object? topic = freezed,
    Object? createdUser = freezed,
    Object? isOwn = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      text: text == freezed
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      viewedTime: viewedTime == freezed
          ? _value.viewedTime
          : viewedTime // ignore: cast_nullable_to_non_nullable
              as int,
      isLike: isLike == freezed
          ? _value.isLike
          : isLike // ignore: cast_nullable_to_non_nullable
              as bool,
      likedTime: likedTime == freezed
          ? _value.likedTime
          : likedTime // ignore: cast_nullable_to_non_nullable
              as int,
      isFavor: isFavor == freezed
          ? _value.isFavor
          : isFavor // ignore: cast_nullable_to_non_nullable
              as bool,
      favoredTime: favoredTime == freezed
          ? _value.favoredTime
          : favoredTime // ignore: cast_nullable_to_non_nullable
              as int,
      point: point == freezed
          ? _value.point
          : point // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      topic: topic == freezed
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as Topic,
      createdUser: createdUser == freezed
          ? _value.createdUser
          : createdUser // ignore: cast_nullable_to_non_nullable
              as User,
      isOwn: isOwn == freezed
          ? _value.isOwn
          : isOwn // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  @override
  $TopicCopyWith<$Res> get topic {
    return $TopicCopyWith<$Res>(_value.topic, (value) {
      return _then(_value.copyWith(topic: value));
    });
  }

  @override
  $UserCopyWith<$Res> get createdUser {
    return $UserCopyWith<$Res>(_value.createdUser, (value) {
      return _then(_value.copyWith(createdUser: value));
    });
  }
}

/// @nodoc
abstract class _$AnswerCopyWith<$Res> implements $AnswerCopyWith<$Res> {
  factory _$AnswerCopyWith(_Answer value, $Res Function(_Answer) then) =
      __$AnswerCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      String text,
      int viewedTime,
      bool isLike,
      int likedTime,
      bool isFavor,
      int favoredTime,
      int point,
      DateTime createdAt,
      Topic topic,
      User createdUser,
      bool isOwn});

  @override
  $TopicCopyWith<$Res> get topic;
  @override
  $UserCopyWith<$Res> get createdUser;
}

/// @nodoc
class __$AnswerCopyWithImpl<$Res> extends _$AnswerCopyWithImpl<$Res>
    implements _$AnswerCopyWith<$Res> {
  __$AnswerCopyWithImpl(_Answer _value, $Res Function(_Answer) _then)
      : super(_value, (v) => _then(v as _Answer));

  @override
  _Answer get _value => super._value as _Answer;

  @override
  $Res call({
    Object? id = freezed,
    Object? text = freezed,
    Object? viewedTime = freezed,
    Object? isLike = freezed,
    Object? likedTime = freezed,
    Object? isFavor = freezed,
    Object? favoredTime = freezed,
    Object? point = freezed,
    Object? createdAt = freezed,
    Object? topic = freezed,
    Object? createdUser = freezed,
    Object? isOwn = freezed,
  }) {
    return _then(_Answer(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      text: text == freezed
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      viewedTime: viewedTime == freezed
          ? _value.viewedTime
          : viewedTime // ignore: cast_nullable_to_non_nullable
              as int,
      isLike: isLike == freezed
          ? _value.isLike
          : isLike // ignore: cast_nullable_to_non_nullable
              as bool,
      likedTime: likedTime == freezed
          ? _value.likedTime
          : likedTime // ignore: cast_nullable_to_non_nullable
              as int,
      isFavor: isFavor == freezed
          ? _value.isFavor
          : isFavor // ignore: cast_nullable_to_non_nullable
              as bool,
      favoredTime: favoredTime == freezed
          ? _value.favoredTime
          : favoredTime // ignore: cast_nullable_to_non_nullable
              as int,
      point: point == freezed
          ? _value.point
          : point // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      topic: topic == freezed
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as Topic,
      createdUser: createdUser == freezed
          ? _value.createdUser
          : createdUser // ignore: cast_nullable_to_non_nullable
              as User,
      isOwn: isOwn == freezed
          ? _value.isOwn
          : isOwn // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_Answer implements _Answer {
  const _$_Answer(
      {required this.id,
      required this.text,
      required this.viewedTime,
      required this.isLike,
      required this.likedTime,
      required this.isFavor,
      required this.favoredTime,
      required this.point,
      required this.createdAt,
      required this.topic,
      required this.createdUser,
      required this.isOwn});

  @override
  final String id;
  @override
  final String text;
  @override
  final int viewedTime;
  @override
  final bool isLike;
  @override
  final int likedTime;
  @override
  final bool isFavor;
  @override
  final int favoredTime;
  @override
  final int point;
  @override
  final DateTime createdAt;
  @override
  final Topic topic;
  @override
  final User createdUser;
  @override
  final bool isOwn;

  @override
  String toString() {
    return 'Answer(id: $id, text: $text, viewedTime: $viewedTime, isLike: $isLike, likedTime: $likedTime, isFavor: $isFavor, favoredTime: $favoredTime, point: $point, createdAt: $createdAt, topic: $topic, createdUser: $createdUser, isOwn: $isOwn)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Answer &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.text, text) ||
                const DeepCollectionEquality().equals(other.text, text)) &&
            (identical(other.viewedTime, viewedTime) ||
                const DeepCollectionEquality()
                    .equals(other.viewedTime, viewedTime)) &&
            (identical(other.isLike, isLike) ||
                const DeepCollectionEquality().equals(other.isLike, isLike)) &&
            (identical(other.likedTime, likedTime) ||
                const DeepCollectionEquality()
                    .equals(other.likedTime, likedTime)) &&
            (identical(other.isFavor, isFavor) ||
                const DeepCollectionEquality()
                    .equals(other.isFavor, isFavor)) &&
            (identical(other.favoredTime, favoredTime) ||
                const DeepCollectionEquality()
                    .equals(other.favoredTime, favoredTime)) &&
            (identical(other.point, point) ||
                const DeepCollectionEquality().equals(other.point, point)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality()
                    .equals(other.createdAt, createdAt)) &&
            (identical(other.topic, topic) ||
                const DeepCollectionEquality().equals(other.topic, topic)) &&
            (identical(other.createdUser, createdUser) ||
                const DeepCollectionEquality()
                    .equals(other.createdUser, createdUser)) &&
            (identical(other.isOwn, isOwn) ||
                const DeepCollectionEquality().equals(other.isOwn, isOwn)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(text) ^
      const DeepCollectionEquality().hash(viewedTime) ^
      const DeepCollectionEquality().hash(isLike) ^
      const DeepCollectionEquality().hash(likedTime) ^
      const DeepCollectionEquality().hash(isFavor) ^
      const DeepCollectionEquality().hash(favoredTime) ^
      const DeepCollectionEquality().hash(point) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(topic) ^
      const DeepCollectionEquality().hash(createdUser) ^
      const DeepCollectionEquality().hash(isOwn);

  @JsonKey(ignore: true)
  @override
  _$AnswerCopyWith<_Answer> get copyWith =>
      __$AnswerCopyWithImpl<_Answer>(this, _$identity);
}

abstract class _Answer implements Answer {
  const factory _Answer(
      {required String id,
      required String text,
      required int viewedTime,
      required bool isLike,
      required int likedTime,
      required bool isFavor,
      required int favoredTime,
      required int point,
      required DateTime createdAt,
      required Topic topic,
      required User createdUser,
      required bool isOwn}) = _$_Answer;

  @override
  String get id => throw _privateConstructorUsedError;
  @override
  String get text => throw _privateConstructorUsedError;
  @override
  int get viewedTime => throw _privateConstructorUsedError;
  @override
  bool get isLike => throw _privateConstructorUsedError;
  @override
  int get likedTime => throw _privateConstructorUsedError;
  @override
  bool get isFavor => throw _privateConstructorUsedError;
  @override
  int get favoredTime => throw _privateConstructorUsedError;
  @override
  int get point => throw _privateConstructorUsedError;
  @override
  DateTime get createdAt => throw _privateConstructorUsedError;
  @override
  Topic get topic => throw _privateConstructorUsedError;
  @override
  User get createdUser => throw _privateConstructorUsedError;
  @override
  bool get isOwn => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$AnswerCopyWith<_Answer> get copyWith => throw _privateConstructorUsedError;
}
