// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

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
      required int viewedCount,
      required bool isLike,
      required int likedCount,
      required bool isFavor,
      required int favoredCount,
      required int popularPoint,
      required String topicId,
      Topic? topic,
      required String createdUserId,
      User? createdUser,
      required DateTime createdAt}) {
    return _Answer(
      id: id,
      text: text,
      viewedCount: viewedCount,
      isLike: isLike,
      likedCount: likedCount,
      isFavor: isFavor,
      favoredCount: favoredCount,
      popularPoint: popularPoint,
      topicId: topicId,
      topic: topic,
      createdUserId: createdUserId,
      createdUser: createdUser,
      createdAt: createdAt,
    );
  }
}

/// @nodoc
const $Answer = _$AnswerTearOff();

/// @nodoc
mixin _$Answer {
  String get id => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  int get viewedCount => throw _privateConstructorUsedError;
  bool get isLike => throw _privateConstructorUsedError;
  int get likedCount => throw _privateConstructorUsedError;
  bool get isFavor => throw _privateConstructorUsedError;
  int get favoredCount => throw _privateConstructorUsedError;
  int get popularPoint => throw _privateConstructorUsedError;
  String get topicId => throw _privateConstructorUsedError;
  Topic? get topic => throw _privateConstructorUsedError;
  String get createdUserId => throw _privateConstructorUsedError;
  User? get createdUser => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

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
      int viewedCount,
      bool isLike,
      int likedCount,
      bool isFavor,
      int favoredCount,
      int popularPoint,
      String topicId,
      Topic? topic,
      String createdUserId,
      User? createdUser,
      DateTime createdAt});

  $TopicCopyWith<$Res>? get topic;
  $UserCopyWith<$Res>? get createdUser;
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
    Object? viewedCount = freezed,
    Object? isLike = freezed,
    Object? likedCount = freezed,
    Object? isFavor = freezed,
    Object? favoredCount = freezed,
    Object? popularPoint = freezed,
    Object? topicId = freezed,
    Object? topic = freezed,
    Object? createdUserId = freezed,
    Object? createdUser = freezed,
    Object? createdAt = freezed,
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
      viewedCount: viewedCount == freezed
          ? _value.viewedCount
          : viewedCount // ignore: cast_nullable_to_non_nullable
              as int,
      isLike: isLike == freezed
          ? _value.isLike
          : isLike // ignore: cast_nullable_to_non_nullable
              as bool,
      likedCount: likedCount == freezed
          ? _value.likedCount
          : likedCount // ignore: cast_nullable_to_non_nullable
              as int,
      isFavor: isFavor == freezed
          ? _value.isFavor
          : isFavor // ignore: cast_nullable_to_non_nullable
              as bool,
      favoredCount: favoredCount == freezed
          ? _value.favoredCount
          : favoredCount // ignore: cast_nullable_to_non_nullable
              as int,
      popularPoint: popularPoint == freezed
          ? _value.popularPoint
          : popularPoint // ignore: cast_nullable_to_non_nullable
              as int,
      topicId: topicId == freezed
          ? _value.topicId
          : topicId // ignore: cast_nullable_to_non_nullable
              as String,
      topic: topic == freezed
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as Topic?,
      createdUserId: createdUserId == freezed
          ? _value.createdUserId
          : createdUserId // ignore: cast_nullable_to_non_nullable
              as String,
      createdUser: createdUser == freezed
          ? _value.createdUser
          : createdUser // ignore: cast_nullable_to_non_nullable
              as User?,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }

  @override
  $TopicCopyWith<$Res>? get topic {
    if (_value.topic == null) {
      return null;
    }

    return $TopicCopyWith<$Res>(_value.topic!, (value) {
      return _then(_value.copyWith(topic: value));
    });
  }

  @override
  $UserCopyWith<$Res>? get createdUser {
    if (_value.createdUser == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.createdUser!, (value) {
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
      int viewedCount,
      bool isLike,
      int likedCount,
      bool isFavor,
      int favoredCount,
      int popularPoint,
      String topicId,
      Topic? topic,
      String createdUserId,
      User? createdUser,
      DateTime createdAt});

  @override
  $TopicCopyWith<$Res>? get topic;
  @override
  $UserCopyWith<$Res>? get createdUser;
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
    Object? viewedCount = freezed,
    Object? isLike = freezed,
    Object? likedCount = freezed,
    Object? isFavor = freezed,
    Object? favoredCount = freezed,
    Object? popularPoint = freezed,
    Object? topicId = freezed,
    Object? topic = freezed,
    Object? createdUserId = freezed,
    Object? createdUser = freezed,
    Object? createdAt = freezed,
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
      viewedCount: viewedCount == freezed
          ? _value.viewedCount
          : viewedCount // ignore: cast_nullable_to_non_nullable
              as int,
      isLike: isLike == freezed
          ? _value.isLike
          : isLike // ignore: cast_nullable_to_non_nullable
              as bool,
      likedCount: likedCount == freezed
          ? _value.likedCount
          : likedCount // ignore: cast_nullable_to_non_nullable
              as int,
      isFavor: isFavor == freezed
          ? _value.isFavor
          : isFavor // ignore: cast_nullable_to_non_nullable
              as bool,
      favoredCount: favoredCount == freezed
          ? _value.favoredCount
          : favoredCount // ignore: cast_nullable_to_non_nullable
              as int,
      popularPoint: popularPoint == freezed
          ? _value.popularPoint
          : popularPoint // ignore: cast_nullable_to_non_nullable
              as int,
      topicId: topicId == freezed
          ? _value.topicId
          : topicId // ignore: cast_nullable_to_non_nullable
              as String,
      topic: topic == freezed
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as Topic?,
      createdUserId: createdUserId == freezed
          ? _value.createdUserId
          : createdUserId // ignore: cast_nullable_to_non_nullable
              as String,
      createdUser: createdUser == freezed
          ? _value.createdUser
          : createdUser // ignore: cast_nullable_to_non_nullable
              as User?,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$_Answer extends _Answer {
  const _$_Answer(
      {required this.id,
      required this.text,
      required this.viewedCount,
      required this.isLike,
      required this.likedCount,
      required this.isFavor,
      required this.favoredCount,
      required this.popularPoint,
      required this.topicId,
      this.topic,
      required this.createdUserId,
      this.createdUser,
      required this.createdAt})
      : super._();

  @override
  final String id;
  @override
  final String text;
  @override
  final int viewedCount;
  @override
  final bool isLike;
  @override
  final int likedCount;
  @override
  final bool isFavor;
  @override
  final int favoredCount;
  @override
  final int popularPoint;
  @override
  final String topicId;
  @override
  final Topic? topic;
  @override
  final String createdUserId;
  @override
  final User? createdUser;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'Answer(id: $id, text: $text, viewedCount: $viewedCount, isLike: $isLike, likedCount: $likedCount, isFavor: $isFavor, favoredCount: $favoredCount, popularPoint: $popularPoint, topicId: $topicId, topic: $topic, createdUserId: $createdUserId, createdUser: $createdUser, createdAt: $createdAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Answer &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.text, text) ||
                const DeepCollectionEquality().equals(other.text, text)) &&
            (identical(other.viewedCount, viewedCount) ||
                const DeepCollectionEquality()
                    .equals(other.viewedCount, viewedCount)) &&
            (identical(other.isLike, isLike) ||
                const DeepCollectionEquality().equals(other.isLike, isLike)) &&
            (identical(other.likedCount, likedCount) ||
                const DeepCollectionEquality()
                    .equals(other.likedCount, likedCount)) &&
            (identical(other.isFavor, isFavor) ||
                const DeepCollectionEquality()
                    .equals(other.isFavor, isFavor)) &&
            (identical(other.favoredCount, favoredCount) ||
                const DeepCollectionEquality()
                    .equals(other.favoredCount, favoredCount)) &&
            (identical(other.popularPoint, popularPoint) ||
                const DeepCollectionEquality()
                    .equals(other.popularPoint, popularPoint)) &&
            (identical(other.topicId, topicId) ||
                const DeepCollectionEquality()
                    .equals(other.topicId, topicId)) &&
            (identical(other.topic, topic) ||
                const DeepCollectionEquality().equals(other.topic, topic)) &&
            (identical(other.createdUserId, createdUserId) ||
                const DeepCollectionEquality()
                    .equals(other.createdUserId, createdUserId)) &&
            (identical(other.createdUser, createdUser) ||
                const DeepCollectionEquality()
                    .equals(other.createdUser, createdUser)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality()
                    .equals(other.createdAt, createdAt)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(text) ^
      const DeepCollectionEquality().hash(viewedCount) ^
      const DeepCollectionEquality().hash(isLike) ^
      const DeepCollectionEquality().hash(likedCount) ^
      const DeepCollectionEquality().hash(isFavor) ^
      const DeepCollectionEquality().hash(favoredCount) ^
      const DeepCollectionEquality().hash(popularPoint) ^
      const DeepCollectionEquality().hash(topicId) ^
      const DeepCollectionEquality().hash(topic) ^
      const DeepCollectionEquality().hash(createdUserId) ^
      const DeepCollectionEquality().hash(createdUser) ^
      const DeepCollectionEquality().hash(createdAt);

  @JsonKey(ignore: true)
  @override
  _$AnswerCopyWith<_Answer> get copyWith =>
      __$AnswerCopyWithImpl<_Answer>(this, _$identity);
}

abstract class _Answer extends Answer {
  const factory _Answer(
      {required String id,
      required String text,
      required int viewedCount,
      required bool isLike,
      required int likedCount,
      required bool isFavor,
      required int favoredCount,
      required int popularPoint,
      required String topicId,
      Topic? topic,
      required String createdUserId,
      User? createdUser,
      required DateTime createdAt}) = _$_Answer;
  const _Answer._() : super._();

  @override
  String get id => throw _privateConstructorUsedError;
  @override
  String get text => throw _privateConstructorUsedError;
  @override
  int get viewedCount => throw _privateConstructorUsedError;
  @override
  bool get isLike => throw _privateConstructorUsedError;
  @override
  int get likedCount => throw _privateConstructorUsedError;
  @override
  bool get isFavor => throw _privateConstructorUsedError;
  @override
  int get favoredCount => throw _privateConstructorUsedError;
  @override
  int get popularPoint => throw _privateConstructorUsedError;
  @override
  String get topicId => throw _privateConstructorUsedError;
  @override
  Topic? get topic => throw _privateConstructorUsedError;
  @override
  String get createdUserId => throw _privateConstructorUsedError;
  @override
  User? get createdUser => throw _privateConstructorUsedError;
  @override
  DateTime get createdAt => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$AnswerCopyWith<_Answer> get copyWith => throw _privateConstructorUsedError;
}
