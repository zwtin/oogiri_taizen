// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

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
      required int answeredTime,
      required DateTime createdAt,
      required User createdUser,
      required bool isOwn}) {
    return _Topic(
      id: id,
      text: text,
      imageUrl: imageUrl,
      answeredTime: answeredTime,
      createdAt: createdAt,
      createdUser: createdUser,
      isOwn: isOwn,
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
  int get answeredTime => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  User get createdUser => throw _privateConstructorUsedError;
  bool get isOwn => throw _privateConstructorUsedError;

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
      int answeredTime,
      DateTime createdAt,
      User createdUser,
      bool isOwn});

  $UserCopyWith<$Res> get createdUser;
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
    Object? answeredTime = freezed,
    Object? createdAt = freezed,
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
      imageUrl: imageUrl == freezed
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      answeredTime: answeredTime == freezed
          ? _value.answeredTime
          : answeredTime // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
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
  $UserCopyWith<$Res> get createdUser {
    return $UserCopyWith<$Res>(_value.createdUser, (value) {
      return _then(_value.copyWith(createdUser: value));
    });
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
      int answeredTime,
      DateTime createdAt,
      User createdUser,
      bool isOwn});

  @override
  $UserCopyWith<$Res> get createdUser;
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
    Object? answeredTime = freezed,
    Object? createdAt = freezed,
    Object? createdUser = freezed,
    Object? isOwn = freezed,
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
      answeredTime: answeredTime == freezed
          ? _value.answeredTime
          : answeredTime // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
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

class _$_Topic implements _Topic {
  const _$_Topic(
      {required this.id,
      required this.text,
      required this.imageUrl,
      required this.answeredTime,
      required this.createdAt,
      required this.createdUser,
      required this.isOwn});

  @override
  final String id;
  @override
  final String text;
  @override
  final String? imageUrl;
  @override
  final int answeredTime;
  @override
  final DateTime createdAt;
  @override
  final User createdUser;
  @override
  final bool isOwn;

  @override
  String toString() {
    return 'Topic(id: $id, text: $text, imageUrl: $imageUrl, answeredTime: $answeredTime, createdAt: $createdAt, createdUser: $createdUser, isOwn: $isOwn)';
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
            (identical(other.answeredTime, answeredTime) ||
                const DeepCollectionEquality()
                    .equals(other.answeredTime, answeredTime)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality()
                    .equals(other.createdAt, createdAt)) &&
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
      const DeepCollectionEquality().hash(imageUrl) ^
      const DeepCollectionEquality().hash(answeredTime) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(createdUser) ^
      const DeepCollectionEquality().hash(isOwn);

  @JsonKey(ignore: true)
  @override
  _$TopicCopyWith<_Topic> get copyWith =>
      __$TopicCopyWithImpl<_Topic>(this, _$identity);
}

abstract class _Topic implements Topic {
  const factory _Topic(
      {required String id,
      required String text,
      required String? imageUrl,
      required int answeredTime,
      required DateTime createdAt,
      required User createdUser,
      required bool isOwn}) = _$_Topic;

  @override
  String get id => throw _privateConstructorUsedError;
  @override
  String get text => throw _privateConstructorUsedError;
  @override
  String? get imageUrl => throw _privateConstructorUsedError;
  @override
  int get answeredTime => throw _privateConstructorUsedError;
  @override
  DateTime get createdAt => throw _privateConstructorUsedError;
  @override
  User get createdUser => throw _privateConstructorUsedError;
  @override
  bool get isOwn => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$TopicCopyWith<_Topic> get copyWith => throw _privateConstructorUsedError;
}
