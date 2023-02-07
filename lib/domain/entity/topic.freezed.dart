// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'topic.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$TopicTearOff {
  const _$TopicTearOff();

  _Topic call(
      {required String id,
      required String text,
      required String? imageUrl,
      required int answeredCount,
      required String userId,
      required DateTime createdAt,
      required DateTime updatedAt,
      required List<TopicAnswer> answers}) {
    return _Topic(
      id: id,
      text: text,
      imageUrl: imageUrl,
      answeredCount: answeredCount,
      userId: userId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      answers: answers,
    );
  }
}

/// @nodoc
const $Topic = _$TopicTearOff();

/// @nodoc
mixin _$Topic {
  String get id => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  int get answeredCount => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  List<TopicAnswer> get answers => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TopicCopyWith<Topic> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopicCopyWith<$Res> {
  factory $TopicCopyWith(Topic value, $Res Function(Topic) then) =
      _$TopicCopyWithImpl<$Res>;
  $Res call(
      {String id,
      String text,
      String? imageUrl,
      int answeredCount,
      String userId,
      DateTime createdAt,
      DateTime updatedAt,
      List<TopicAnswer> answers});
}

/// @nodoc
class _$TopicCopyWithImpl<$Res> implements $TopicCopyWith<$Res> {
  _$TopicCopyWithImpl(this._value, this._then);

  final Topic _value;
  // ignore: unused_field
  final $Res Function(Topic) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? text = freezed,
    Object? imageUrl = freezed,
    Object? answeredCount = freezed,
    Object? userId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? answers = freezed,
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
      imageUrl: imageUrl == freezed
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      answeredCount: answeredCount == freezed
          ? _value.answeredCount
          : answeredCount // ignore: cast_nullable_to_non_nullable
              as int,
      userId: userId == freezed
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: updatedAt == freezed
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      answers: answers == freezed
          ? _value.answers
          : answers // ignore: cast_nullable_to_non_nullable
              as List<TopicAnswer>,
    ));
  }
}

/// @nodoc
abstract class _$TopicCopyWith<$Res> implements $TopicCopyWith<$Res> {
  factory _$TopicCopyWith(_Topic value, $Res Function(_Topic) then) =
      __$TopicCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      String text,
      String? imageUrl,
      int answeredCount,
      String userId,
      DateTime createdAt,
      DateTime updatedAt,
      List<TopicAnswer> answers});
}

/// @nodoc
class __$TopicCopyWithImpl<$Res> extends _$TopicCopyWithImpl<$Res>
    implements _$TopicCopyWith<$Res> {
  __$TopicCopyWithImpl(_Topic _value, $Res Function(_Topic) _then)
      : super(_value, (v) => _then(v as _Topic));

  @override
  _Topic get _value => super._value as _Topic;

  @override
  $Res call({
    Object? id = freezed,
    Object? text = freezed,
    Object? imageUrl = freezed,
    Object? answeredCount = freezed,
    Object? userId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? answers = freezed,
  }) {
    return _then(_Topic(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      text: text == freezed
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: imageUrl == freezed
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      answeredCount: answeredCount == freezed
          ? _value.answeredCount
          : answeredCount // ignore: cast_nullable_to_non_nullable
              as int,
      userId: userId == freezed
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: updatedAt == freezed
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      answers: answers == freezed
          ? _value.answers
          : answers // ignore: cast_nullable_to_non_nullable
              as List<TopicAnswer>,
    ));
  }
}

/// @nodoc

class _$_Topic extends _Topic {
  const _$_Topic(
      {required this.id,
      required this.text,
      required this.imageUrl,
      required this.answeredCount,
      required this.userId,
      required this.createdAt,
      required this.updatedAt,
      required this.answers})
      : super._();

  @override
  final String id;
  @override
  final String text;
  @override
  final String? imageUrl;
  @override
  final int answeredCount;
  @override
  final String userId;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final List<TopicAnswer> answers;

  @override
  String toString() {
    return 'Topic(id: $id, text: $text, imageUrl: $imageUrl, answeredCount: $answeredCount, userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt, answers: $answers)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Topic &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.text, text) ||
                const DeepCollectionEquality().equals(other.text, text)) &&
            (identical(other.imageUrl, imageUrl) ||
                const DeepCollectionEquality()
                    .equals(other.imageUrl, imageUrl)) &&
            (identical(other.answeredCount, answeredCount) ||
                const DeepCollectionEquality()
                    .equals(other.answeredCount, answeredCount)) &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality()
                    .equals(other.createdAt, createdAt)) &&
            (identical(other.updatedAt, updatedAt) ||
                const DeepCollectionEquality()
                    .equals(other.updatedAt, updatedAt)) &&
            (identical(other.answers, answers) ||
                const DeepCollectionEquality().equals(other.answers, answers)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(text) ^
      const DeepCollectionEquality().hash(imageUrl) ^
      const DeepCollectionEquality().hash(answeredCount) ^
      const DeepCollectionEquality().hash(userId) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(updatedAt) ^
      const DeepCollectionEquality().hash(answers);

  @JsonKey(ignore: true)
  @override
  _$TopicCopyWith<_Topic> get copyWith =>
      __$TopicCopyWithImpl<_Topic>(this, _$identity);
}

abstract class _Topic extends Topic {
  const factory _Topic(
      {required String id,
      required String text,
      required String? imageUrl,
      required int answeredCount,
      required String userId,
      required DateTime createdAt,
      required DateTime updatedAt,
      required List<TopicAnswer> answers}) = _$_Topic;
  const _Topic._() : super._();

  @override
  String get id => throw _privateConstructorUsedError;
  @override
  String get text => throw _privateConstructorUsedError;
  @override
  String? get imageUrl => throw _privateConstructorUsedError;
  @override
  int get answeredCount => throw _privateConstructorUsedError;
  @override
  String get userId => throw _privateConstructorUsedError;
  @override
  DateTime get createdAt => throw _privateConstructorUsedError;
  @override
  DateTime get updatedAt => throw _privateConstructorUsedError;
  @override
  List<TopicAnswer> get answers => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$TopicCopyWith<_Topic> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
class _$TopicAnswerTearOff {
  const _$TopicAnswerTearOff();

  _TopicAnswer call(
      {required String id,
      required DateTime createdAt,
      required DateTime updatedAt}) {
    return _TopicAnswer(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

/// @nodoc
const $TopicAnswer = _$TopicAnswerTearOff();

/// @nodoc
mixin _$TopicAnswer {
  String get id => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TopicAnswerCopyWith<TopicAnswer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopicAnswerCopyWith<$Res> {
  factory $TopicAnswerCopyWith(
          TopicAnswer value, $Res Function(TopicAnswer) then) =
      _$TopicAnswerCopyWithImpl<$Res>;
  $Res call({String id, DateTime createdAt, DateTime updatedAt});
}

/// @nodoc
class _$TopicAnswerCopyWithImpl<$Res> implements $TopicAnswerCopyWith<$Res> {
  _$TopicAnswerCopyWithImpl(this._value, this._then);

  final TopicAnswer _value;
  // ignore: unused_field
  final $Res Function(TopicAnswer) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: updatedAt == freezed
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
abstract class _$TopicAnswerCopyWith<$Res>
    implements $TopicAnswerCopyWith<$Res> {
  factory _$TopicAnswerCopyWith(
          _TopicAnswer value, $Res Function(_TopicAnswer) then) =
      __$TopicAnswerCopyWithImpl<$Res>;
  @override
  $Res call({String id, DateTime createdAt, DateTime updatedAt});
}

/// @nodoc
class __$TopicAnswerCopyWithImpl<$Res> extends _$TopicAnswerCopyWithImpl<$Res>
    implements _$TopicAnswerCopyWith<$Res> {
  __$TopicAnswerCopyWithImpl(
      _TopicAnswer _value, $Res Function(_TopicAnswer) _then)
      : super(_value, (v) => _then(v as _TopicAnswer));

  @override
  _TopicAnswer get _value => super._value as _TopicAnswer;

  @override
  $Res call({
    Object? id = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_TopicAnswer(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: updatedAt == freezed
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$_TopicAnswer extends _TopicAnswer {
  const _$_TopicAnswer(
      {required this.id, required this.createdAt, required this.updatedAt})
      : super._();

  @override
  final String id;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'TopicAnswer(id: $id, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _TopicAnswer &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality()
                    .equals(other.createdAt, createdAt)) &&
            (identical(other.updatedAt, updatedAt) ||
                const DeepCollectionEquality()
                    .equals(other.updatedAt, updatedAt)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(updatedAt);

  @JsonKey(ignore: true)
  @override
  _$TopicAnswerCopyWith<_TopicAnswer> get copyWith =>
      __$TopicAnswerCopyWithImpl<_TopicAnswer>(this, _$identity);
}

abstract class _TopicAnswer extends TopicAnswer {
  const factory _TopicAnswer(
      {required String id,
      required DateTime createdAt,
      required DateTime updatedAt}) = _$_TopicAnswer;
  const _TopicAnswer._() : super._();

  @override
  String get id => throw _privateConstructorUsedError;
  @override
  DateTime get createdAt => throw _privateConstructorUsedError;
  @override
  DateTime get updatedAt => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$TopicAnswerCopyWith<_TopicAnswer> get copyWith =>
      throw _privateConstructorUsedError;
}
