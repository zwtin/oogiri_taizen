// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$UserTearOff {
  const _$UserTearOff();

  _User call(
      {required String id,
      required String name,
      required String? imageUrl,
      required String introduction,
      required DateTime createdAt,
      required DateTime updatedAt,
      required List<UserCreateTopic> createTopics,
      required List<UserCreateAnswer> createAnswers,
      required List<UserLikeAnswer> likeAnswers,
      required List<UserFavorAnswer> favorAnswers}) {
    return _User(
      id: id,
      name: name,
      imageUrl: imageUrl,
      introduction: introduction,
      createdAt: createdAt,
      updatedAt: updatedAt,
      createTopics: createTopics,
      createAnswers: createAnswers,
      likeAnswers: likeAnswers,
      favorAnswers: favorAnswers,
    );
  }
}

/// @nodoc
const $User = _$UserTearOff();

/// @nodoc
mixin _$User {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String get introduction => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  List<UserCreateTopic> get createTopics => throw _privateConstructorUsedError;
  List<UserCreateAnswer> get createAnswers =>
      throw _privateConstructorUsedError;
  List<UserLikeAnswer> get likeAnswers => throw _privateConstructorUsedError;
  List<UserFavorAnswer> get favorAnswers => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res>;
  $Res call(
      {String id,
      String name,
      String? imageUrl,
      String introduction,
      DateTime createdAt,
      DateTime updatedAt,
      List<UserCreateTopic> createTopics,
      List<UserCreateAnswer> createAnswers,
      List<UserLikeAnswer> likeAnswers,
      List<UserFavorAnswer> favorAnswers});
}

/// @nodoc
class _$UserCopyWithImpl<$Res> implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  final User _value;
  // ignore: unused_field
  final $Res Function(User) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? imageUrl = freezed,
    Object? introduction = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? createTopics = freezed,
    Object? createAnswers = freezed,
    Object? likeAnswers = freezed,
    Object? favorAnswers = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: imageUrl == freezed
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      introduction: introduction == freezed
          ? _value.introduction
          : introduction // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: updatedAt == freezed
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createTopics: createTopics == freezed
          ? _value.createTopics
          : createTopics // ignore: cast_nullable_to_non_nullable
              as List<UserCreateTopic>,
      createAnswers: createAnswers == freezed
          ? _value.createAnswers
          : createAnswers // ignore: cast_nullable_to_non_nullable
              as List<UserCreateAnswer>,
      likeAnswers: likeAnswers == freezed
          ? _value.likeAnswers
          : likeAnswers // ignore: cast_nullable_to_non_nullable
              as List<UserLikeAnswer>,
      favorAnswers: favorAnswers == freezed
          ? _value.favorAnswers
          : favorAnswers // ignore: cast_nullable_to_non_nullable
              as List<UserFavorAnswer>,
    ));
  }
}

/// @nodoc
abstract class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) then) =
      __$UserCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      String name,
      String? imageUrl,
      String introduction,
      DateTime createdAt,
      DateTime updatedAt,
      List<UserCreateTopic> createTopics,
      List<UserCreateAnswer> createAnswers,
      List<UserLikeAnswer> likeAnswers,
      List<UserFavorAnswer> favorAnswers});
}

/// @nodoc
class __$UserCopyWithImpl<$Res> extends _$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(_User _value, $Res Function(_User) _then)
      : super(_value, (v) => _then(v as _User));

  @override
  _User get _value => super._value as _User;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? imageUrl = freezed,
    Object? introduction = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? createTopics = freezed,
    Object? createAnswers = freezed,
    Object? likeAnswers = freezed,
    Object? favorAnswers = freezed,
  }) {
    return _then(_User(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: imageUrl == freezed
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      introduction: introduction == freezed
          ? _value.introduction
          : introduction // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: updatedAt == freezed
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createTopics: createTopics == freezed
          ? _value.createTopics
          : createTopics // ignore: cast_nullable_to_non_nullable
              as List<UserCreateTopic>,
      createAnswers: createAnswers == freezed
          ? _value.createAnswers
          : createAnswers // ignore: cast_nullable_to_non_nullable
              as List<UserCreateAnswer>,
      likeAnswers: likeAnswers == freezed
          ? _value.likeAnswers
          : likeAnswers // ignore: cast_nullable_to_non_nullable
              as List<UserLikeAnswer>,
      favorAnswers: favorAnswers == freezed
          ? _value.favorAnswers
          : favorAnswers // ignore: cast_nullable_to_non_nullable
              as List<UserFavorAnswer>,
    ));
  }
}

/// @nodoc

class _$_User extends _User {
  const _$_User(
      {required this.id,
      required this.name,
      required this.imageUrl,
      required this.introduction,
      required this.createdAt,
      required this.updatedAt,
      required this.createTopics,
      required this.createAnswers,
      required this.likeAnswers,
      required this.favorAnswers})
      : super._();

  @override
  final String id;
  @override
  final String name;
  @override
  final String? imageUrl;
  @override
  final String introduction;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final List<UserCreateTopic> createTopics;
  @override
  final List<UserCreateAnswer> createAnswers;
  @override
  final List<UserLikeAnswer> likeAnswers;
  @override
  final List<UserFavorAnswer> favorAnswers;

  @override
  String toString() {
    return 'User(id: $id, name: $name, imageUrl: $imageUrl, introduction: $introduction, createdAt: $createdAt, updatedAt: $updatedAt, createTopics: $createTopics, createAnswers: $createAnswers, likeAnswers: $likeAnswers, favorAnswers: $favorAnswers)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _User &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.imageUrl, imageUrl) ||
                const DeepCollectionEquality()
                    .equals(other.imageUrl, imageUrl)) &&
            (identical(other.introduction, introduction) ||
                const DeepCollectionEquality()
                    .equals(other.introduction, introduction)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality()
                    .equals(other.createdAt, createdAt)) &&
            (identical(other.updatedAt, updatedAt) ||
                const DeepCollectionEquality()
                    .equals(other.updatedAt, updatedAt)) &&
            (identical(other.createTopics, createTopics) ||
                const DeepCollectionEquality()
                    .equals(other.createTopics, createTopics)) &&
            (identical(other.createAnswers, createAnswers) ||
                const DeepCollectionEquality()
                    .equals(other.createAnswers, createAnswers)) &&
            (identical(other.likeAnswers, likeAnswers) ||
                const DeepCollectionEquality()
                    .equals(other.likeAnswers, likeAnswers)) &&
            (identical(other.favorAnswers, favorAnswers) ||
                const DeepCollectionEquality()
                    .equals(other.favorAnswers, favorAnswers)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(imageUrl) ^
      const DeepCollectionEquality().hash(introduction) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(updatedAt) ^
      const DeepCollectionEquality().hash(createTopics) ^
      const DeepCollectionEquality().hash(createAnswers) ^
      const DeepCollectionEquality().hash(likeAnswers) ^
      const DeepCollectionEquality().hash(favorAnswers);

  @JsonKey(ignore: true)
  @override
  _$UserCopyWith<_User> get copyWith =>
      __$UserCopyWithImpl<_User>(this, _$identity);
}

abstract class _User extends User {
  const factory _User(
      {required String id,
      required String name,
      required String? imageUrl,
      required String introduction,
      required DateTime createdAt,
      required DateTime updatedAt,
      required List<UserCreateTopic> createTopics,
      required List<UserCreateAnswer> createAnswers,
      required List<UserLikeAnswer> likeAnswers,
      required List<UserFavorAnswer> favorAnswers}) = _$_User;
  const _User._() : super._();

  @override
  String get id => throw _privateConstructorUsedError;
  @override
  String get name => throw _privateConstructorUsedError;
  @override
  String? get imageUrl => throw _privateConstructorUsedError;
  @override
  String get introduction => throw _privateConstructorUsedError;
  @override
  DateTime get createdAt => throw _privateConstructorUsedError;
  @override
  DateTime get updatedAt => throw _privateConstructorUsedError;
  @override
  List<UserCreateTopic> get createTopics => throw _privateConstructorUsedError;
  @override
  List<UserCreateAnswer> get createAnswers =>
      throw _privateConstructorUsedError;
  @override
  List<UserLikeAnswer> get likeAnswers => throw _privateConstructorUsedError;
  @override
  List<UserFavorAnswer> get favorAnswers => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$UserCopyWith<_User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
class _$UserCreateTopicTearOff {
  const _$UserCreateTopicTearOff();

  _UserCreateTopic call(
      {required String id,
      required DateTime createdAt,
      required DateTime updatedAt}) {
    return _UserCreateTopic(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

/// @nodoc
const $UserCreateTopic = _$UserCreateTopicTearOff();

/// @nodoc
mixin _$UserCreateTopic {
  String get id => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserCreateTopicCopyWith<UserCreateTopic> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCreateTopicCopyWith<$Res> {
  factory $UserCreateTopicCopyWith(
          UserCreateTopic value, $Res Function(UserCreateTopic) then) =
      _$UserCreateTopicCopyWithImpl<$Res>;
  $Res call({String id, DateTime createdAt, DateTime updatedAt});
}

/// @nodoc
class _$UserCreateTopicCopyWithImpl<$Res>
    implements $UserCreateTopicCopyWith<$Res> {
  _$UserCreateTopicCopyWithImpl(this._value, this._then);

  final UserCreateTopic _value;
  // ignore: unused_field
  final $Res Function(UserCreateTopic) _then;

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
abstract class _$UserCreateTopicCopyWith<$Res>
    implements $UserCreateTopicCopyWith<$Res> {
  factory _$UserCreateTopicCopyWith(
          _UserCreateTopic value, $Res Function(_UserCreateTopic) then) =
      __$UserCreateTopicCopyWithImpl<$Res>;
  @override
  $Res call({String id, DateTime createdAt, DateTime updatedAt});
}

/// @nodoc
class __$UserCreateTopicCopyWithImpl<$Res>
    extends _$UserCreateTopicCopyWithImpl<$Res>
    implements _$UserCreateTopicCopyWith<$Res> {
  __$UserCreateTopicCopyWithImpl(
      _UserCreateTopic _value, $Res Function(_UserCreateTopic) _then)
      : super(_value, (v) => _then(v as _UserCreateTopic));

  @override
  _UserCreateTopic get _value => super._value as _UserCreateTopic;

  @override
  $Res call({
    Object? id = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_UserCreateTopic(
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

class _$_UserCreateTopic extends _UserCreateTopic {
  const _$_UserCreateTopic(
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
    return 'UserCreateTopic(id: $id, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _UserCreateTopic &&
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
  _$UserCreateTopicCopyWith<_UserCreateTopic> get copyWith =>
      __$UserCreateTopicCopyWithImpl<_UserCreateTopic>(this, _$identity);
}

abstract class _UserCreateTopic extends UserCreateTopic {
  const factory _UserCreateTopic(
      {required String id,
      required DateTime createdAt,
      required DateTime updatedAt}) = _$_UserCreateTopic;
  const _UserCreateTopic._() : super._();

  @override
  String get id => throw _privateConstructorUsedError;
  @override
  DateTime get createdAt => throw _privateConstructorUsedError;
  @override
  DateTime get updatedAt => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$UserCreateTopicCopyWith<_UserCreateTopic> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
class _$UserCreateAnswerTearOff {
  const _$UserCreateAnswerTearOff();

  _UserCreateAnswer call(
      {required String id,
      required DateTime createdAt,
      required DateTime updatedAt}) {
    return _UserCreateAnswer(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

/// @nodoc
const $UserCreateAnswer = _$UserCreateAnswerTearOff();

/// @nodoc
mixin _$UserCreateAnswer {
  String get id => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserCreateAnswerCopyWith<UserCreateAnswer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCreateAnswerCopyWith<$Res> {
  factory $UserCreateAnswerCopyWith(
          UserCreateAnswer value, $Res Function(UserCreateAnswer) then) =
      _$UserCreateAnswerCopyWithImpl<$Res>;
  $Res call({String id, DateTime createdAt, DateTime updatedAt});
}

/// @nodoc
class _$UserCreateAnswerCopyWithImpl<$Res>
    implements $UserCreateAnswerCopyWith<$Res> {
  _$UserCreateAnswerCopyWithImpl(this._value, this._then);

  final UserCreateAnswer _value;
  // ignore: unused_field
  final $Res Function(UserCreateAnswer) _then;

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
abstract class _$UserCreateAnswerCopyWith<$Res>
    implements $UserCreateAnswerCopyWith<$Res> {
  factory _$UserCreateAnswerCopyWith(
          _UserCreateAnswer value, $Res Function(_UserCreateAnswer) then) =
      __$UserCreateAnswerCopyWithImpl<$Res>;
  @override
  $Res call({String id, DateTime createdAt, DateTime updatedAt});
}

/// @nodoc
class __$UserCreateAnswerCopyWithImpl<$Res>
    extends _$UserCreateAnswerCopyWithImpl<$Res>
    implements _$UserCreateAnswerCopyWith<$Res> {
  __$UserCreateAnswerCopyWithImpl(
      _UserCreateAnswer _value, $Res Function(_UserCreateAnswer) _then)
      : super(_value, (v) => _then(v as _UserCreateAnswer));

  @override
  _UserCreateAnswer get _value => super._value as _UserCreateAnswer;

  @override
  $Res call({
    Object? id = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_UserCreateAnswer(
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

class _$_UserCreateAnswer extends _UserCreateAnswer {
  const _$_UserCreateAnswer(
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
    return 'UserCreateAnswer(id: $id, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _UserCreateAnswer &&
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
  _$UserCreateAnswerCopyWith<_UserCreateAnswer> get copyWith =>
      __$UserCreateAnswerCopyWithImpl<_UserCreateAnswer>(this, _$identity);
}

abstract class _UserCreateAnswer extends UserCreateAnswer {
  const factory _UserCreateAnswer(
      {required String id,
      required DateTime createdAt,
      required DateTime updatedAt}) = _$_UserCreateAnswer;
  const _UserCreateAnswer._() : super._();

  @override
  String get id => throw _privateConstructorUsedError;
  @override
  DateTime get createdAt => throw _privateConstructorUsedError;
  @override
  DateTime get updatedAt => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$UserCreateAnswerCopyWith<_UserCreateAnswer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
class _$UserLikeAnswerTearOff {
  const _$UserLikeAnswerTearOff();

  _UserLikeAnswer call(
      {required String id,
      required DateTime createdAt,
      required DateTime updatedAt}) {
    return _UserLikeAnswer(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

/// @nodoc
const $UserLikeAnswer = _$UserLikeAnswerTearOff();

/// @nodoc
mixin _$UserLikeAnswer {
  String get id => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserLikeAnswerCopyWith<UserLikeAnswer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserLikeAnswerCopyWith<$Res> {
  factory $UserLikeAnswerCopyWith(
          UserLikeAnswer value, $Res Function(UserLikeAnswer) then) =
      _$UserLikeAnswerCopyWithImpl<$Res>;
  $Res call({String id, DateTime createdAt, DateTime updatedAt});
}

/// @nodoc
class _$UserLikeAnswerCopyWithImpl<$Res>
    implements $UserLikeAnswerCopyWith<$Res> {
  _$UserLikeAnswerCopyWithImpl(this._value, this._then);

  final UserLikeAnswer _value;
  // ignore: unused_field
  final $Res Function(UserLikeAnswer) _then;

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
abstract class _$UserLikeAnswerCopyWith<$Res>
    implements $UserLikeAnswerCopyWith<$Res> {
  factory _$UserLikeAnswerCopyWith(
          _UserLikeAnswer value, $Res Function(_UserLikeAnswer) then) =
      __$UserLikeAnswerCopyWithImpl<$Res>;
  @override
  $Res call({String id, DateTime createdAt, DateTime updatedAt});
}

/// @nodoc
class __$UserLikeAnswerCopyWithImpl<$Res>
    extends _$UserLikeAnswerCopyWithImpl<$Res>
    implements _$UserLikeAnswerCopyWith<$Res> {
  __$UserLikeAnswerCopyWithImpl(
      _UserLikeAnswer _value, $Res Function(_UserLikeAnswer) _then)
      : super(_value, (v) => _then(v as _UserLikeAnswer));

  @override
  _UserLikeAnswer get _value => super._value as _UserLikeAnswer;

  @override
  $Res call({
    Object? id = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_UserLikeAnswer(
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

class _$_UserLikeAnswer extends _UserLikeAnswer {
  const _$_UserLikeAnswer(
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
    return 'UserLikeAnswer(id: $id, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _UserLikeAnswer &&
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
  _$UserLikeAnswerCopyWith<_UserLikeAnswer> get copyWith =>
      __$UserLikeAnswerCopyWithImpl<_UserLikeAnswer>(this, _$identity);
}

abstract class _UserLikeAnswer extends UserLikeAnswer {
  const factory _UserLikeAnswer(
      {required String id,
      required DateTime createdAt,
      required DateTime updatedAt}) = _$_UserLikeAnswer;
  const _UserLikeAnswer._() : super._();

  @override
  String get id => throw _privateConstructorUsedError;
  @override
  DateTime get createdAt => throw _privateConstructorUsedError;
  @override
  DateTime get updatedAt => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$UserLikeAnswerCopyWith<_UserLikeAnswer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
class _$UserFavorAnswerTearOff {
  const _$UserFavorAnswerTearOff();

  _UserFavorAnswer call(
      {required String id,
      required DateTime createdAt,
      required DateTime updatedAt}) {
    return _UserFavorAnswer(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

/// @nodoc
const $UserFavorAnswer = _$UserFavorAnswerTearOff();

/// @nodoc
mixin _$UserFavorAnswer {
  String get id => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserFavorAnswerCopyWith<UserFavorAnswer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserFavorAnswerCopyWith<$Res> {
  factory $UserFavorAnswerCopyWith(
          UserFavorAnswer value, $Res Function(UserFavorAnswer) then) =
      _$UserFavorAnswerCopyWithImpl<$Res>;
  $Res call({String id, DateTime createdAt, DateTime updatedAt});
}

/// @nodoc
class _$UserFavorAnswerCopyWithImpl<$Res>
    implements $UserFavorAnswerCopyWith<$Res> {
  _$UserFavorAnswerCopyWithImpl(this._value, this._then);

  final UserFavorAnswer _value;
  // ignore: unused_field
  final $Res Function(UserFavorAnswer) _then;

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
abstract class _$UserFavorAnswerCopyWith<$Res>
    implements $UserFavorAnswerCopyWith<$Res> {
  factory _$UserFavorAnswerCopyWith(
          _UserFavorAnswer value, $Res Function(_UserFavorAnswer) then) =
      __$UserFavorAnswerCopyWithImpl<$Res>;
  @override
  $Res call({String id, DateTime createdAt, DateTime updatedAt});
}

/// @nodoc
class __$UserFavorAnswerCopyWithImpl<$Res>
    extends _$UserFavorAnswerCopyWithImpl<$Res>
    implements _$UserFavorAnswerCopyWith<$Res> {
  __$UserFavorAnswerCopyWithImpl(
      _UserFavorAnswer _value, $Res Function(_UserFavorAnswer) _then)
      : super(_value, (v) => _then(v as _UserFavorAnswer));

  @override
  _UserFavorAnswer get _value => super._value as _UserFavorAnswer;

  @override
  $Res call({
    Object? id = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_UserFavorAnswer(
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

class _$_UserFavorAnswer extends _UserFavorAnswer {
  const _$_UserFavorAnswer(
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
    return 'UserFavorAnswer(id: $id, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _UserFavorAnswer &&
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
  _$UserFavorAnswerCopyWith<_UserFavorAnswer> get copyWith =>
      __$UserFavorAnswerCopyWithImpl<_UserFavorAnswer>(this, _$identity);
}

abstract class _UserFavorAnswer extends UserFavorAnswer {
  const factory _UserFavorAnswer(
      {required String id,
      required DateTime createdAt,
      required DateTime updatedAt}) = _$_UserFavorAnswer;
  const _UserFavorAnswer._() : super._();

  @override
  String get id => throw _privateConstructorUsedError;
  @override
  DateTime get createdAt => throw _privateConstructorUsedError;
  @override
  DateTime get updatedAt => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$UserFavorAnswerCopyWith<_UserFavorAnswer> get copyWith =>
      throw _privateConstructorUsedError;
}
